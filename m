Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558AbaHOFmR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 01:42:17 -0400
Received: from mail6.autoliv.com ([195.33.130.243]:40426 "EHLO
	mail6.autoliv.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaHOFmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 01:42:16 -0400
From: Mattis Lorentzon <Mattis.Lorentzon@autoliv.com>
To: Fabio Estevam <festevam@gmail.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Fredrik Noring <fredrik.noring@autoliv.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: Oops: 17 SMP ARM (v3.16-rc2)
Thread-Topic: Oops: 17 SMP ARM (v3.16-rc2)
Thread-Index: Ac+QeuMIv4ry9FBDTNKHf1ccZ0ioqQAu3GGAAAUkuuD//+tKAIABUVuA//+RU9CAAMUXAP/CyllwgHui4wD//8wREAAM+aMA//6IPID//QHtAP/4Df8A/+ub5xD/1wicgP+rMUjQ/1SejoD+qU6QAP1RkiKw
Date: Fri, 15 Aug 2014 05:42:12 +0000
Message-ID: <C4A61A5CA4AD2246942F4BA6F20ACB8043577770@ALVA-EXMB04.alv.autoliv.int>
References: <20140626151424.GT32514@n2100.arm.linux.org.uk>
	<20140627112151.GF32514@n2100.arm.linux.org.uk>
	<3FFB61A7A8473C49831AF20FA193534A43CADFA7@ALVA-EXMB01.alv.autoliv.int>
	<20140627163108.GP32514@n2100.arm.linux.org.uk>
	<C4A61A5CA4AD2246942F4BA6F20ACB8043575072@ALVA-EXMB04.alv.autoliv.int>
	<20140806095012.GN30282@n2100.arm.linux.org.uk>
	<C4A61A5CA4AD2246942F4BA6F20ACB8043575172@ALVA-EXMB04.alv.autoliv.int>
	<20140806125550.GO30282@n2100.arm.linux.org.uk>
	<C4A61A5CA4AD2246942F4BA6F20ACB804357526C@ALVA-EXMB04.alv.autoliv.int>
	<20140807121248.GY30282@n2100.arm.linux.org.uk>
	<20140808180900.GG30282@n2100.arm.linux.org.uk>
	<C4A61A5CA4AD2246942F4BA6F20ACB8043576356@ALVA-EXMB04.alv.autoliv.int>
	<CAOMZO5B8GR+ABBoJ=dJcFqw3Wagfaip7HM+C1FTz+aE4CmqiPw@mail.gmail.com>
	<C4A61A5CA4AD2246942F4BA6F20ACB80435776D3@ALVA-EXMB04.alv.autoliv.int>
 <CAOMZO5B7FgzB7ThVyV2Vk7wTwYgjRWjEnkkAN5uwwKMaBKq1yg@mail.gmail.com>
In-Reply-To: <CAOMZO5B7FgzB7ThVyV2Vk7wTwYgjRWjEnkkAN5uwwKMaBKq1yg@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s7F5gNit031810

Fabio,

> Do the stalls also happen on a pure 3.16 kernel?

Yes, we just tried this out overnight and we get the same stalls here.
We have seen similar problems on a Zynq-based board. It might be
worth noting that a common chip between all three boards is, for
example, the KSZ9021RN, while the FEC driver, for example, only
runs on the two iMX6-boards.

> How can we reproduce the error?

We mostly run SSH with benchmarks using NFS, it can probably be
triggered by using only SSH with the following loop:

# while : ; do ssh arm-card date; done

Our (pure) 3.16 kernel uses the following config.
http://lkml.iu.edu/hypermail/linux/kernel/1408.1/03045/config.gz

(We have quite generously disabled a lot of sub-systems in our config.)

Best regards,
Mattis Lorentzon

***************************************************************
Consider the environment before printing this message.

To read Autoliv's Information and Confidentiality Notice, follow this link:
http://www.autoliv.com/disclaimer.html
***************************************************************ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
