Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398AbaEYDNk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 23:13:40 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:45056 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751262AbaEYDNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 23:13:39 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcUAE1fgVNXQDTn/2dsb2JhbABZgweCRX6nUgEBAQEBAQUBgzyUSgICAYEDF3SCJQEBBAE6HCMFCwgDGB0ROR4GE4g6DAHXTBeFVYg0SQeEQAEDjz+KMwGLF4gQgzo7gTE
Date: Sun, 25 May 2014 05:13:38 +0200
From: Fabian Frederick <fabf@skynet.be>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/4] lib/debugobjects.c: move __initdata after name
Message-Id: <20140525051338.44cbb304b48f28625fa60c1b@skynet.be>
In-Reply-To: <20140524215634.GC24038@thin>
References: <1400936839-25007-1-git-send-email-fabf@skynet.be>
	<20140524215634.GC24038@thin>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 May 2014 14:56:35 -0700
Josh Triplett <josh@joshtriplett.org> wrote:

> On Sat, May 24, 2014 at 03:07:19PM +0200, Fabian Frederick wrote:
> > Cc: Josh Triplett <josh@joshtriplett.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Fabian Frederick <fabf@skynet.be>
> 
> No, don't make this change.  A quick "git grep __initdata" shows that to
> the extent it has a consistent placement, it's either right after the
> type ("static some_type __initdata varname") or right after the storage
> class ("static __initdata some_type varname").  Other similar qualifiers
> follow the same pattern.

It was another checkpatch warning asking to put __initdata after variable name...
