Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab3IWOUj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 10:20:39 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50329 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab3IWOUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 10:20:39 -0400
Message-ID: <52404E12.5060407@kernel.dk>
Date: Mon, 23 Sep 2013 08:20:02 -0600
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
References: <5230cf49.xeAraX9UUfBD+Brs%fengguang.wu@intel.com> <87B0A48E21A1974AB4780BA3191524C20E62C5@MYMBX4.stec-inc.ad> <52332E6B.9060405@kernel.dk> <87B0A48E21A1974AB4780BA3191524C20E6446@MYMBX4.stec-inc.ad>,<20130918143616.GD28478@kernel.dk>,<87B0A48E21A1974AB4780BA3191524C20E64FB@MYMBX4.stec-inc.ad> <87B0A48E21A1974AB4780BA3191524C20F6553@MYMBX3.stec-inc.ad>
In-Reply-To: <87B0A48E21A1974AB4780BA3191524C20F6553@MYMBX3.stec-inc.ad>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2013 05:59 AM, Akhil Bhansali wrote:
> Hello Jens,
> 
> I am sending a patch created on top of "Andrew's latest changes" to disable the 32 bit compilation of kronos driver.
> 
> The patch takes care of following.
> 1. checkpatch.pl was showing 3 errors for assignment in if condition, I have got rid of that.
> 2. removal of readq / readl functions which are not used in the code.
> 3. warnings related to VPRINTKs for 64 bit compilation after latest fix from Andrew.

Thanks, things are improving. I will apply it.

-- 
Jens Axboe

