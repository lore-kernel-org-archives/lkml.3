Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638AbaBDPPM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 10:15:12 -0500
Received: from andromeda.dapyr.net ([206.212.254.10]:57411 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbaBDPPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 10:15:08 -0500
Date: Tue, 4 Feb 2014 11:15:01 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Roger Pau Monne <roger.pau@citrix.com>, mrushton@amazon.com,
        msw@amazon.com
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH v2 0/4] xen-blk: bug fixes
Message-ID: <20140204151501.GA1781@andromeda.dapyr.net>
References: <1391509575-3949-1-git-send-email-roger.pau@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391509575-3949-1-git-send-email-roger.pau@citrix.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 11:26:11AM +0100, Roger Pau Monne wrote:
> This series contain blkback bug fixes for memory leaks (patches 1 and 
> 2) and a race (patch 3). Patch 4 removes blkif_request_segment_aligned 
> since its memory layout is exactly the same as blkif_request_segment 
> and should introduce no functional change.
> 
> All patches should be backported to stable branches, although the last 
> one is not a functional change it will still be nice to have it for 
> code correctness.

Matt and Matt, could you guys kindly take a look as well? Thank you!

> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
