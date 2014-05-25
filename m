Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449AbaEYDRX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 23:17:23 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:20924 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751262AbaEYDRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 23:17:22 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhMgAIhfgVNXQDTn/2dsb2JhbABZgweCRX6nUgEBAQEBAQUBgzyUSAICAQEBgQMXdIIlAQEEATocIwULCAMYHRE5HgYTiDoMAddMF4VViH0HhEABA48/ijMBkyeDOjs
Date: Sun, 25 May 2014 05:17:22 +0200
From: Fabian Frederick <fabf@skynet.be>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4] lib/debugobjects.c: code clean-up
Message-Id: <20140525051722.c4f8864706786d9b3805fd10@skynet.be>
In-Reply-To: <20140524220009.GD24038@thin>
References: <1400936886-25055-1-git-send-email-fabf@skynet.be>
	<20140524220009.GD24038@thin>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 May 2014 15:00:09 -0700
Josh Triplett <josh@joshtriplett.org> wrote:

> On Sat, May 24, 2014 at 03:08:06PM +0200, Fabian Frederick wrote:
> > Fix some checkpatch warnings.
> > 
> > Cc: Josh Triplett <josh@joshtriplett.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Fabian Frederick <fabf@skynet.be>
> 
> Some of these make sense, one of them does not.  Comments below.
> 
> Also, please explicitly note the checkpatch warnings you fixed, not just
> "Fix some checkpatch warnings.".
ok
