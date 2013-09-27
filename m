Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397Ab3I0SM7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 14:12:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60088 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988Ab3I0SM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 14:12:56 -0400
Message-ID: <5245CA7C.7090306@kernel.dk>
Date: Fri, 27 Sep 2013 12:12:12 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Akhil Bhansali <Akhil.Bhansali@hgst.com>
CC: kbuild test robot <fengguang.wu@intel.com>,
        OS Engineering <osengineering@stec-inc.com>,
        Ramprasad Chinthekindi <Ramprasad.Chinthekindi@hgst.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Amit Phansalkar <Amit.Phansalkar@hgst.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [block:for-next 5/6] drivers/block/skd_main.c:441:3: error: implicit
 declaration of function 'readq'
References: <5230cf49.xeAraX9UUfBD+Brs%fengguang.wu@intel.com> <87B0A48E21A1974AB4780BA3191524C20E62C5@MYMBX4.stec-inc.ad> <52332E6B.9060405@kernel.dk> <87B0A48E21A1974AB4780BA3191524C20E6446@MYMBX4.stec-inc.ad>,<20130918143616.GD28478@kernel.dk>,<87B0A48E21A1974AB4780BA3191524C20E64FB@MYMBX4.stec-inc.ad> <87B0A48E21A1974AB4780BA3191524C20F6553@MYMBX3.stec-inc.ad>,<52404E12.5060407@kernel.dk> <87B0A48E21A1974AB4780BA3191524C20FAA88@MYMBX3.stec-inc.ad>
In-Reply-To: <87B0A48E21A1974AB4780BA3191524C20FAA88@MYMBX3.stec-inc.ad>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2013 05:26 AM, Akhil Bhansali wrote:
> Hello Jens,
> 
> There are few improvements suggested by community for driver:
> 1. Replacement of custom macros for debug printing. (DPRINTK / VPRINTK).
> 2. Reformatting of "skd_request_fn" which is too long.
> 
> Kindly let us know if you see any other changes required before it can be moved  to mainline kernel.

Did you forget to attach the patch?

-- 
Jens Axboe

