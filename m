Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751304AbaK1B6O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 20:58:14 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:54269 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaK1B6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 20:58:06 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID sAS1vN8F029045, This message is accepted by code: ctloc85258
From: =?gb2312?B?vrTI8Q==?= <micky_ching@realsil.com.cn>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "chris@printf.net" <chris@printf.net>,
        "ulf.hansson@linaro.org" <ulf.hansson@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?gb2312?B?zfXsvw==?= <wei_wang@realsil.com.cn>,
        "rogerable@realtek.com" <rogerable@realtek.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [PATCH 2/2] mmc: rtsx: add support for sdio card
Thread-Topic: [PATCH 2/2] mmc: rtsx: add support for sdio card
Thread-Index: AQHQCe2KYhnF4EIkV0G++vyW+di17Jx0F9MAgACrgQA=
Date: Fri, 28 Nov 2014 01:57:22 +0000
Message-ID: <5477D682.30107@realsil.com.cn>
References: <cover.1417056337.git.micky_ching@realsil.com.cn>
 <671243677462065a8eb515d654c8a269ce73409c.1417056337.git.micky_ching@realsil.com.cn>
 <20141127154332.GB4860@mwanda>
In-Reply-To: <20141127154332.GB4860@mwanda>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.29.41.103]
Content-Type: text/plain; charset="gb2312"
Content-ID: <9950A8276D5FAC47AD7AD1D5DCB680C7@realsil.com.cn>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAS1wVN5028558


On 11/27/2014 11:43 PM, Dan Carpenter wrote:
>> +	int stat_idx = sd_status_index(rsp_type);
> I have always hated this terrible pointer math.  5 is relative to
> pcr->host_cmds_ptr + 1.  It's a mess...
5 mean CRC7 offset of Response R1, see SD spec V3.01 Page 82.
4.9.1 R1 (normal response command).

And we have to +1 to skip unused/undefined data.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
