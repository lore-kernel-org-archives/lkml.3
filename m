Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbbASCcz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 21:32:55 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:37812 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbbASCcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 21:32:53 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID t0J2WHKb032051, This message is accepted by code: ctloc85258
From: =?utf-8?B?5pWs6ZSQ?= <micky_ching@realsil.com.cn>
To: Lee Jones <lee.jones@linaro.org>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rogerable@realtek.com" <rogerable@realtek.com>,
        =?utf-8?B?546L54Kc?= <wei_wang@realsil.com.cn>
Subject: Re: [PATCH 08/10] mfd: rtsx: add support for rts524A
Thread-Topic: [PATCH 08/10] mfd: rtsx: add support for rts524A
Thread-Index: AQHQMxk67WPZwH/qcEuSOn1+BP1sXJzGM/gA
Date: Mon, 19 Jan 2015 02:32:16 +0000
Message-ID: <54BC6CB0.6090402@realsil.com.cn>
References: <cover.1421320541.git.micky_ching@realsil.com.cn>
 <007fcaa1986088c968cd4d1627c294a55df73e9f.1421320541.git.micky_ching@realsil.com.cn>
 <20150118122055.GK3574@x1>
In-Reply-To: <20150118122055.GK3574@x1>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.29.41.103]
Content-Type: text/plain; charset="utf-8"
Content-ID: <50452DDF46EBE0499FEE4D720962878E@realsil.com.cn>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0J2X1YH000303


On 01/18/2015 08:20 PM, Lee Jones wrote:
>> @@ -72,8 +72,10 @@ static void rts5249_fetch_vendor_settings(struct rtsx_pcr *pcr)
>> >  	rtsx_pci_read_config_dword(pcr, PCR_SETTING_REG1, &reg);
>> >  	dev_dbg(&(pcr->pci->dev), "Cfg 0x%x: 0x%x\n", PCR_SETTING_REG1, reg);
>> >  
>> >-	if (!rtsx_vendor_setting_valid(reg))
>> >+	if (!rtsx_vendor_setting_valid(reg)) {
>> >+		pcr_dbg(pcr, "skip fetch vendor setting\n");
>> >  		return;
>> >+	}
> This doesn't have anything to do with adding the new chip.
>
> And I'm not sure it's even required.
>
Yes, it can be removed, but it is useful for debug,
help us to know whether config is load from hardware.ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
