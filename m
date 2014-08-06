Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbaHFGs2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 02:48:28 -0400
Received: from mail6.autoliv.com ([195.33.130.243]:44117 "EHLO
	mail6.autoliv.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319AbaHFGs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 02:48:26 -0400
From: Mattis Lorentzon <Mattis.Lorentzon@autoliv.com>
To: Fabio Estevam <festevam@gmail.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Fredrik Noring <fredrik.noring@autoliv.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: Oops: 17 SMP ARM (v3.16-rc2)
Thread-Topic: Oops: 17 SMP ARM (v3.16-rc2)
Thread-Index: Ac+QeuMIv4ry9FBDTNKHf1ccZ0ioqQAu3GGAAAUkuuD//+tKAIABUVuA//+RU9CAAMUXAP/CyllwgHpUfoD//9zKgA==
Date: Wed, 6 Aug 2014 06:48:23 +0000
Message-ID: <C4A61A5CA4AD2246942F4BA6F20ACB80435750AA@ALVA-EXMB04.alv.autoliv.int>
References: <C4A61A5CA4AD2246942F4BA6F20ACB804356534D@ALVA-EXMB04.alv.autoliv.int>
	<20140626140115.GQ32514@n2100.arm.linux.org.uk>
	<C4A61A5CA4AD2246942F4BA6F20ACB80435655E9@ALVA-EXMB04.alv.autoliv.int>
	<20140626151424.GT32514@n2100.arm.linux.org.uk>
	<20140627112151.GF32514@n2100.arm.linux.org.uk>
	<3FFB61A7A8473C49831AF20FA193534A43CADFA7@ALVA-EXMB01.alv.autoliv.int>
	<20140627163108.GP32514@n2100.arm.linux.org.uk>
	<C4A61A5CA4AD2246942F4BA6F20ACB8043575072@ALVA-EXMB04.alv.autoliv.int>
 <CAOMZO5BdPKZSV4mQMA+vCJFpZ2KV6fooLNH2TvfvvVto+Eb2JA@mail.gmail.com>
In-Reply-To: <CAOMZO5BdPKZSV4mQMA+vCJFpZ2KV6fooLNH2TvfvvVto+Eb2JA@mail.gmail.com>
Accept-Language: sv-SE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.14.8.137]
Content-Type: text/plain;
	charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s766mXDB009591

Hi Fabio,

> Could this problem be the same one as reported at:
> http://www.spinics.net/lists/arm-kernel/msg347914.html ?

The problem you link to describes a permanent issue, our problem seems
to be sporadic as most of our tests work fine (at least for a while).

> Which Ethernet PHY do you use? Do you have pull-up in the MDIO line?

Our hardware has the KSZ9021RN PHY, so the MDIO line should be pull-up.

Do you know if there are debug options that could help us determine the
cause of the timeout?

Best regards,
Mattis Lorentzon

***************************************************************
Consider the environment before printing this message.

To read Autoliv's Information and Confidentiality Notice, follow this link:
http://www.autoliv.com/disclaimer.html
***************************************************************ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
