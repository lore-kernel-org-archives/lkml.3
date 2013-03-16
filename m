Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918Ab3CPOzT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 10:55:19 -0400
Received: from f286.mail.ru ([217.69.128.253]:43949 "EHLO f286.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755829Ab3CPOzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 10:55:17 -0400
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?TWF4aW1lIFJpcGFyZA==?= <maxime.ripard@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?Um9iIEhlcnJpbmc=?= <rob.herring@calxeda.com>,
        =?UTF-8?B?R3JhbnQgTGlrZWx5?= <grant.likely@secretlab.ca>,
        =?UTF-8?B?Um9iIExhbmRsZXk=?= <rob@landley.net>,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        =?UTF-8?B?U3RlZmFuIFJvZXNl?= <sr@denx.de>, kevin@allwinnertech.com
Subject: =?UTF-8?B?UmU6IFtQQVRDSCAxLzVdIG5ldDogQWRkIGRhdmljb20gd2VtYWMgZXRoZXJu?=
 =?UTF-8?B?ZXQgZHJpdmVyIGZvdW5kIG9uIEFsbHdpbm5lciBBMTAgU29DJ3M=?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [188.134.40.128]
Date: Sat, 16 Mar 2013 18:55:10 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1363445710.396407038@f286.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Spam: Not detected
X-Mras: Ok
In-Reply-To: <1363380605-6577-2-git-send-email-maxime.ripard@free-electrons.com>
References: <1363380605-6577-1-git-send-email-maxime.ripard@free-electrons.com> <1363380605-6577-2-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2GEtOL6009367

> From: Stefan Roese <sr@denx.de>
> 
> The Allwinner A10 has an ethernet controller that is advertised as
> coming from Davicom.
> 
> The exact feature set of this controller is unknown, since there is no
> public documentation for this IP, and this driver is mostly the one
> published by Allwinner that has been heavily cleaned up.
...
> +Example:
> +
> +wemac: ethernet@01c0b000 {
> +       compatible = "davicom,wemac";
> +       reg = <0x01c0b000 0x1000>;
> +       interrupts = <55>;
> +       allwinner,power-gpios = <&pio 7 19 0>;

I think regulator API is better for use for this.
And gpio-regulator for this case.

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
