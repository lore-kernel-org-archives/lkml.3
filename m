Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737AbbASDJu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 22:09:50 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:49037 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbbASDJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 22:09:50 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID t0J39XPV029407, This message is accepted by code: ctloc85258
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
Thread-Index: AQHQMxk67WPZwH/qcEuSOn1+BP1sXJzGPmOA
Date: Mon, 19 Jan 2015 03:09:32 +0000
Message-ID: <54BC756D.1000102@realsil.com.cn>
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
Content-ID: <0803A090FB5FA04584007C93C1DC2C45@realsil.com.cn>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0J39tUk000377


On 01/18/2015 08:20 PM, Lee Jones wrote:
>> +};
>> >+
>> >+void rts524a_init_params(struct rtsx_pcr *pcr)
>> >+{
>> >+	rts5249_init_params(pcr);
>> >+
>> >+	pcr->ops = &rts524a_pcr_ops;
>> >+}
> I see a couple of these now.  Why don't you make 'ops' a parameter of
> *_init_params().
>
*_init_params() is called from rtsx_pcr.c, and the ops parameter should
be static, if we make ops as a parameter, the rts524a_pcr_ops defination
should move to rtsx_pcr.c, not reasonable.ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
