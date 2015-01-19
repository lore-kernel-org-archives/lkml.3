Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbbASCyN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 21:54:13 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:50316 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbbASCyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 21:54:12 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID t0J2rpJ7019610, This message is accepted by code: ctloc85258
From: =?utf-8?B?5pWs6ZSQ?= <micky_ching@realsil.com.cn>
To: Lee Jones <lee.jones@linaro.org>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rogerable@realtek.com" <rogerable@realtek.com>,
        =?utf-8?B?546L54Kc?= <wei_wang@realsil.com.cn>
Subject: Re: [PATCH 09/10] mfd: rtsx: add support for rts525A
Thread-Topic: [PATCH 09/10] mfd: rtsx: add support for rts525A
Thread-Index: AQHQMw/gx8aF/NYUFEqyWqI0jH0+RJzGOhCA
Date: Mon, 19 Jan 2015 02:53:49 +0000
Message-ID: <54BC71BD.2030202@realsil.com.cn>
References: <cover.1421320541.git.micky_ching@realsil.com.cn>
 <06f009ff0bdcb1183412cb0172dc687f0b173747.1421320541.git.micky_ching@realsil.com.cn>
 <20150118111339.GJ3574@x1>
In-Reply-To: <20150118111339.GJ3574@x1>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.29.41.103]
Content-Type: text/plain; charset="utf-8"
Content-ID: <09113E2257998E41ACAA9C6EC9813310@realsil.com.cn>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0J2sVrh000340


On 01/18/2015 07:13 PM, Lee Jones wrote:
>> @@ -97,7 +97,7 @@ static void rts5249_force_power_down(struct rtsx_pcr *pcr, u8 pm_state)
>> >  	rtsx_pci_write_register(pcr, AUTOLOAD_CFG_BASE + 3, 0x01, 0);
>> >  
>> >  	if (pm_state == HOST_ENTER_S3) {
>> >-		if (PCI_PID(pcr) == 0x524A)
>> >+		if (PCI_PID(pcr) == 0x524A || PCI_PID(pcr) == 0x525A)
> Shouldn't these be defined somewhere?
>
> I have a particular distaste for magic numbers.
>
This is the chip ID number, no need define, just using it.
if we define, it will like RTS525A_PCI_ID, so bad.ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
