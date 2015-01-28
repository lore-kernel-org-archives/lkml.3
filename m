Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759624AbbA1BNz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:13:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40887 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755000AbbA1BNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:13:54 -0500
Date: Tue, 27 Jan 2015 17:13:53 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Jiri Slaby <jslaby@suse.cz>, Linux-Stable <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/97] Misc series of functional/performance fixes for
 3.12-stable
Message-ID: <20150128011353.GA24412@kroah.com>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 07:34:08PM +0100, Mel Gorman wrote:
> Kernel Summit 2014 had a topic on performance regressions and catching
> them.  The situation relatively recently has been good but I believe this
> is partially due to major distributions stabilising recently and hardware
> vendors working on performance for their latest platforms. On thing I fear is
> that we miss performance regressions because releases contains performance
> gains and losses, some of which balance out. After a number of mainline
> releases, the performance may look ok but in comparison to a distribution
> kernel cherry-picking the picture is not as rosy.  The 3.0-longterm
> included a number of performance-related patches so it could be used as
> a good performance baseline for later releases. It is no longer maintained.
> 
> This series contains a large number of patches against 3.12-longterm that
> never made it to stable as the bugs were not serious enough or they were
> performance patches. 3.10-longterm may need other pre-requisites I did
> not research and 3.14-longterm should be able to apply a subset although
> I have not tested the result.
> 

I've finally applied the rest of these to the 3.14-stable queue, thanks
again for providing them.

greg k-h
