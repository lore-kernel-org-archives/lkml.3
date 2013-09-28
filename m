Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab3I1CsB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 22:48:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38022 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130Ab3I1CsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 22:48:00 -0400
Date: Fri, 27 Sep 2013 20:47:51 -0600
From: Jens Axboe <axboe@kernel.dk>
To: Akhil Bhansali <Akhil.Bhansali@hgst.com>
Cc: kbuild test robot <fengguang.wu@intel.com>,
        OS Engineering <osengineering@stec-inc.com>,
        Ramprasad Chinthekindi <Ramprasad.Chinthekindi@hgst.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Amit Phansalkar <Amit.Phansalkar@hgst.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [block:for-next 5/6] drivers/block/skd_main.c:441:3: error:
 implicit declaration of function 'readq'
Message-ID: <20130928024751.GA5434@kernel.dk>
References: <5230cf49.xeAraX9UUfBD+Brs%fengguang.wu@intel.com>
 <87B0A48E21A1974AB4780BA3191524C20E62C5@MYMBX4.stec-inc.ad>
 <52332E6B.9060405@kernel.dk>
 <87B0A48E21A1974AB4780BA3191524C20E6446@MYMBX4.stec-inc.ad>
 <20130918143616.GD28478@kernel.dk>
 <87B0A48E21A1974AB4780BA3191524C20E64FB@MYMBX4.stec-inc.ad>
 <87B0A48E21A1974AB4780BA3191524C20F6553@MYMBX3.stec-inc.ad>
 <52404E12.5060407@kernel.dk>
 <87B0A48E21A1974AB4780BA3191524C20FAA88@MYMBX3.stec-inc.ad>
 <5245CA7C.7090306@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5245CA7C.7090306@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27 2013, Jens Axboe wrote:
> On 09/27/2013 05:26 AM, Akhil Bhansali wrote:
> > Hello Jens,
> > 
> > There are few improvements suggested by community for driver:
> > 1. Replacement of custom macros for debug printing. (DPRINTK / VPRINTK).
> > 2. Reformatting of "skd_request_fn" which is too long.
> > 
> > Kindly let us know if you see any other changes required before it can be moved  to mainline kernel.
> 
> Did you forget to attach the patch?

Sorry, I misread that initially. The major eye sore right now is the
PRINTK stuff. The refactor of the request_fn would be a plus. Start with
those two, and I'll take a look and see if we need to do more right now.

-- 
Jens Axboe

