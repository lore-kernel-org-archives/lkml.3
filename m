Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab3IROgY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 10:36:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45923 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab3IROgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 10:36:23 -0400
Date: Wed, 18 Sep 2013 08:36:16 -0600
From: Jens Axboe <axboe@kernel.dk>
To: Akhil Bhansali <AkhilAshok.Bhansali@hgst.com>
Cc: kbuild test robot <fengguang.wu@intel.com>,
        OS Engineering <osengineering@stec-inc.com>,
        Ramprasad Chinthekindi <Ramprasad.Chinthekindi@hgst.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Amit Phansalkar <Amit.Phansalkar@hgst.com>
Subject: Re: [block:for-next 5/6] drivers/block/skd_main.c:441:3: error:
 implicit declaration of function 'readq'
Message-ID: <20130918143616.GD28478@kernel.dk>
References: <5230cf49.xeAraX9UUfBD+Brs%fengguang.wu@intel.com>
 <87B0A48E21A1974AB4780BA3191524C20E62C5@MYMBX4.stec-inc.ad>
 <52332E6B.9060405@kernel.dk>
 <87B0A48E21A1974AB4780BA3191524C20E6446@MYMBX4.stec-inc.ad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87B0A48E21A1974AB4780BA3191524C20E6446@MYMBX4.stec-inc.ad>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18 2013, Akhil Bhansali wrote:
> Hi Jens,
> 
> Please accept this patch that takes care of warnings related to i386 compilation.
> 1. Implicit function declaration of readq and writeq.
> 2. Format related warnings for VPRINTK.

You should get rid of the VPRINTK() as well, we do have debug facilities
in place you can use for printing.

And as mentioned a week or so ago, readq() isn't even used.

-- 
Jens Axboe

