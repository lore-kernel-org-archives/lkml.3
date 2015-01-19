Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506AbbASCgk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 21:36:40 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:38063 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbbASCgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 21:36:39 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID t0J2aIY7006362, This message is accepted by code: ctloc85258
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
Thread-Index: AQHQMxk67WPZwH/qcEuSOn1+BP1sXJzGNReA
Date: Mon, 19 Jan 2015 02:36:17 +0000
Message-ID: <54BC6DA1.80205@realsil.com.cn>
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
Content-ID: <0FA31AB8FD145347BD01FAB285A2861A@realsil.com.cn>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0J2ajua000310


On 01/18/2015 08:20 PM, Lee Jones wrote:
>> +static int rts524a_optimize_phy(struct rtsx_pcr *pcr)
>> >+{
>> >+	int err;
>> >+
>> >+	err = rtsx_pci_write_register(pcr, RTS524A_PM_CTRL3,
>> >+		D3_DELINK_MODE_EN, 0x00);
>> >+	if (err < 0)
>> >+		return err;
> if (err)
>
err value will never be positive, but I have to make it consistence
with driver in other place, because all the check using if (err < 0) form.
And maybe, it make reserved for future the function may return positive
value.ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
