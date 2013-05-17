Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339Ab3EQDDs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 23:03:48 -0400
Received: from hop-nat-141.emc.com ([168.159.213.141]:37913 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751591Ab3EQDDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 23:03:46 -0400
From: "Peng, Tao" <tao.peng@emc.com>
To: Greg KH <gregkh@linuxfoundation.org>, Cyril Roelandt <tipecaml@gmail.com>
CC: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "andreas.dilger@intel.com" <andreas.dilger@intel.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] staging: lustre: fix return type of lo_release.
Thread-Topic: [PATCH] staging: lustre: fix return type of lo_release.
Thread-Index: AQHOUlHYocvJB+cfUkGriSdAkRTs9JkIbfYAgABDF1A=
Date: Fri, 17 May 2013 03:03:12 +0000
Message-ID: <1882637210201641A747464075FFC64904175946@MX101CL02.corp.emc.com>
References: <1368720380-20974-1-git-send-email-tipecaml@gmail.com>
 <20130516190130.GB2778@kroah.com>
In-Reply-To: <20130516190130.GB2778@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.32.218.60]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EMM-MHVC: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4H33qqe026617


> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Friday, May 17, 2013 3:02 AM
> To: Cyril Roelandt
> Cc: kernel-janitors@vger.kernel.org; andreas.dilger@intel.com; Peng, Tao; devel@driverdev.osuosl.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] staging: lustre: fix return type of lo_release.
> 
> On Thu, May 16, 2013 at 06:06:20PM +0200, Cyril Roelandt wrote:
> > The return type of block_device_operations.release() changed to void in commit
> > db2a144b.
> 
> Interesting, how did you test build this patch, given that the driver
> doesn't currently build at all?  :)
> 
> Anyway, thanks, I'll go queue this up.
My stupid email client... Just saw this one. Please ignore my previous mail. Sorry for the noise.

Thanks,
Tao


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
