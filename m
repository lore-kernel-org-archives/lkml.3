Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab3AaKLr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 05:11:47 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:38458 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446Ab3AaKLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 05:11:44 -0500
From: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "khilman@deeprootsystems.com" <khilman@deeprootsystems.com>
Subject: RE: [PATCH RFC] davinci: poll for sleep completion in resume
 routine.
Thread-Topic: [PATCH RFC] davinci: poll for sleep completion in resume
 routine.
Thread-Index: AQHN/5XxpHn9OjBrUkS7PDbkGefup5hi1cUAgABgJMA=
Date: Thu, 31 Jan 2013 10:11:30 +0000
Message-ID: <A4887BF146CD57468F700B415D2F4701581C4A@DBDE01.ent.ti.com>
References: <1359624393-5898-1-git-send-email-manishv.b@ti.com>
 <510A3EAE.107@ti.com>
In-Reply-To: <510A3EAE.107@ti.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0VABkXB019491

Hi Sekhar

On Thu, Jan 31, 2013 at 15:21:42, Nori, Sekhar wrote:
> 
> 
> On 1/31/2013 2:56 PM, Vishwanathrao Badarkhe, Manish wrote:
> > As per OMAP-L138 TRM, Software must poll for SLEEPCOMPLETE bit until 
> > it is set to 1 before clearing SLEEPENABLE bit in DEEPSLEEP register 
> > in resume routine.
> > Modifications are as per datasheet:
> > http://www.ti.com/lit/ug/spruh77a/spruh77a.pdf
> > See sections 10.10.2.2 and 11.5.21 for more detailed explanation.
> > 
> > Tested on da850-evm.
> > 
> > Signed-off-by: Vishwanathrao Badarkhe, Manish <manishv.b@ti.com>
> 
> Is this a bug fix? Do you see any issue without this patch?

This is not a bug fix. I have not seen any issue without this patch. 
Only, modifications are done as per OMAP-L138 TRM.   

> 
> Thanks,
> Sekhar
> 


Regards, 
Manish
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
