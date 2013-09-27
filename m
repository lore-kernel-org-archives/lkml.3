Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab3I0L1t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 07:27:49 -0400
Received: from mysmtp1.stec-inc.com ([1.9.68.9]:42559 "HELO
	stec-inc.com.stec-inc.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1750966Ab3I0L1q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 07:27:46 -0400
X-ASG-Debug-ID: 1380281259-053ea9589029b3a0001-xx1T2L
X-Barracuda-Envelope-From: Akhil.Bhansali@hgst.com
From: Akhil Bhansali <Akhil.Bhansali@hgst.com>
To: Jens Axboe <axboe@kernel.dk>
CC: kbuild test robot <fengguang.wu@intel.com>,
        OS Engineering <osengineering@stec-inc.com>,
        Ramprasad Chinthekindi <Ramprasad.Chinthekindi@hgst.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Amit Phansalkar" <Amit.Phansalkar@hgst.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: RE: [block:for-next 5/6] drivers/block/skd_main.c:441:3: error:
 implicit declaration of function 'readq'
Thread-Topic: [block:for-next 5/6] drivers/block/skd_main.c:441:3: error:
 implicit declaration of function 'readq'
X-ASG-Orig-Subj: RE: [block:for-next 5/6] drivers/block/skd_main.c:441:3: error:
 implicit declaration of function 'readq'
Thread-Index: AQHOryuGetr1quWh0UWdC/r7zgDmkZnDouGK//+jooCACAdm4P//xoAAgAHuFHSABkKTFP//pngAANOJCx0=
Date: Fri, 27 Sep 2013 11:26:31 +0000
Message-ID: <87B0A48E21A1974AB4780BA3191524C20FAA88@MYMBX3.stec-inc.ad>
References: <5230cf49.xeAraX9UUfBD+Brs%fengguang.wu@intel.com>
 <87B0A48E21A1974AB4780BA3191524C20E62C5@MYMBX4.stec-inc.ad>
 <52332E6B.9060405@kernel.dk>
 <87B0A48E21A1974AB4780BA3191524C20E6446@MYMBX4.stec-inc.ad>,<20130918143616.GD28478@kernel.dk>,<87B0A48E21A1974AB4780BA3191524C20E64FB@MYMBX4.stec-inc.ad>
 <87B0A48E21A1974AB4780BA3191524C20F6553@MYMBX3.stec-inc.ad>,<52404E12.5060407@kernel.dk>
In-Reply-To: <52404E12.5060407@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [14.140.125.250]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Barracuda-Connect: mycas03.stec-inc.ad[172.30.8.21]
X-Barracuda-Start-Time: 1380281259
X-Barracuda-URL: http://myspam1.stec-inc.com:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.140973
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jens,

There are few improvements suggested by community for driver:
1. Replacement of custom macros for debug printing. (DPRINTK / VPRINTK).
2. Reformatting of "skd_request_fn" which is too long.

Kindly let us know if you see any other changes required before it can be moved  to mainline kernel.

Thank you.

Regards,
Akhil
________________________________________
From: Jens Axboe [axboe@kernel.dk]
Sent: Monday, September 23, 2013 7:50 PM
To: Akhil Bhansali
Cc: kbuild test robot; OS Engineering; Ramprasad Chinthekindi; jmoyer@redhat.com; linux-kernel@vger.kernel.org; Amit Phansalkar; Andrew Morton
Subject: Re: [block:for-next 5/6] drivers/block/skd_main.c:441:3: error: implicit declaration of function 'readq'

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

PROPRIETARY-CONFIDENTIAL INFORMATION INCLUDED



This electronic transmission, and any documents attached hereto, may contain confidential, proprietary and/or legally privileged information. The information is intended only for use by the recipient named above. If you received this electronic message in error, please notify the sender and delete the electronic message. Any disclosure, copying, distribution, or use of the contents of information received in error is strictly prohibited, and violators will be pursued legally.
