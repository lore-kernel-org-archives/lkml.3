Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478Ab3JYLYl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 07:24:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33473 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab3JYLYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 07:24:40 -0400
Date: Fri, 25 Oct 2013 12:24:30 +0100
From: Jens Axboe <axboe@kernel.dk>
To: Joe Perches <joe@perches.com>
Cc: Ramprasad Chinthekindi <Ramprasad.Chinthekindi@hgst.com>,
        Akhil Bhansali <Akhil.Bhansali@hgst.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Amit Phansalkar <Amit.Phansalkar@hgst.com>
Subject: Re: [PATCH] skd: Replaced custom debug PRINTKs with pr_debug
Message-ID: <20131025112430.GE6285@kernel.dk>
References: <24CA9A5C93173F48A9E3313B866A7C280F344E@MYMBX3.stec-inc.ad>
 <20131024115304.GW14598@kernel.dk>
 <1382627375.22433.58.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382627375.22433.58.camel@joe-AO722>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24 2013, Joe Perches wrote:
> On Thu, 2013-10-24 at 12:53 +0100, Jens Axboe wrote:
> > On Thu, Oct 24 2013, Ramprasad Chinthekindi wrote:
> > > Hi Jens,
> > > 
> > > I'm resending the patch to replace custom debug macros with
> > > pr_debug(). Kindly please review and apply the patch.  Thanking you.
> > 
> > Thanks, that's a nice improvement. Applied.
> 
> Is it really much of an improvement?
> 
> It leaves possible different behavior with
> skdev->dbg_level/skd_dbg_level set without
> linkage to a few printks now.
> 
> It also doesn't make use of dynamic debug's
> +f/+l capability to and always emits
> __func__/__LINE__.

It's an improvement from a private FOOPRINTK() macro. Feel free to send
in further improvements.

-- 
Jens Axboe

