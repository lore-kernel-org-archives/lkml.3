Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbaBFE5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 23:57:36 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:33107 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478AbaBFE5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 23:57:35 -0500
Date: Wed, 5 Feb 2014 20:57:30 -0800
From: Matt Wilson <msw@linux.com>
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
Cc: Roger Pau Monne <roger.pau@citrix.com>, mrushton@amazon.com,
        msw@amazon.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH v2 0/4] xen-blk: bug fixes
Message-ID: <20140206045729.GA15901@u109add4315675089e695.ant.amazon.com>
References: <1391509575-3949-1-git-send-email-roger.pau@citrix.com>
 <20140204151501.GA1781@andromeda.dapyr.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140204151501.GA1781@andromeda.dapyr.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 11:15:01AM -0400, Konrad Rzeszutek Wilk wrote:
> On Tue, Feb 04, 2014 at 11:26:11AM +0100, Roger Pau Monne wrote:
> > This series contain blkback bug fixes for memory leaks (patches 1 and 
> > 2) and a race (patch 3). Patch 4 removes blkif_request_segment_aligned 
> > since its memory layout is exactly the same as blkif_request_segment 
> > and should introduce no functional change.
> > 
> > All patches should be backported to stable branches, although the last 
> > one is not a functional change it will still be nice to have it for 
> > code correctness.
> 
> Matt and Matt, could you guys kindly take a look as well? Thank you!

Matt R. did some testing today and set up additional tests to run
overnight. He'll follow up after the overnight tests complete.

--msw
