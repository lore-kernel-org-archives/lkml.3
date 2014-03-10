Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412AbaCJWOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 18:14:22 -0400
Received: from one.firstfloor.org ([193.170.194.197]:46742 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbaCJWOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 18:14:21 -0400
Date: Mon, 10 Mar 2014 23:14:20 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>, acme@infradead.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org, eranian@google.com,
        namhyung@kernel.org, jolsa@redhat.com
Subject: Re: perf: Add support for full Intel event lists
Message-ID: <20140310221420.GM22728@two.firstfloor.org>
References: <1394048978-15909-1-git-send-email-andi@firstfloor.org>
 <1394480354.23624.7.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394480354.23624.7.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 07:39:14PM +0000, Ben Hutchings wrote:
> On Wed, 2014-03-05 at 11:49 -0800, Andi Kleen wrote:
> [...]
> > I implemented an automatic downloader to get the event file for the
> > current CPU.  The events are stored in ~/.events.
> [...]
> 
> This directory should be placed under $XDG_CACHE_DIR (default:
> ~/.cache), and should have a more specific name like 'perf-events'.

Ok.

I don't like calling it perf-events because it will be used
by other non perf tools too. I guess pmu-events could do.

> 
> It might be useful to also support a system directory for these,
> under /var/cache.

I don't want people shipping those.  It just causes lots 
of outdated events everywhere, like in oprofile.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
