Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773AbaHVGjH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 02:39:07 -0400
Received: from mail6.autoliv.com ([195.33.130.243]:39885 "EHLO
	mail6.autoliv.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbaHVGjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 02:39:04 -0400
From: Mattis Lorentzon <Mattis.Lorentzon@autoliv.com>
To: Fabio Estevam <festevam@gmail.com>, Iain Paton <ipaton0@gmail.com>
CC: Fredrik Noring <fredrik.noring@autoliv.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: Oops: 17 SMP ARM (v3.16-rc2)
Thread-Topic: Oops: 17 SMP ARM (v3.16-rc2)
Thread-Index: Ac+QeuMIv4ry9FBDTNKHf1ccZ0ioqQAu3GGAAAUkuuD//+tKAIABUVuA//+RU9CAAMUXAP/CyllwgHui4wD//8wREAAM+aMA//6IPID//QHtAP/4Df8A/+ub5xD/1wicgP+rMUjQ/1SejoD+qU6QAP1RkiKw+p8SkAD1PiHLAOp6Jo+A1PDsGICp4OdZgNPBS/lA
Date: Fri, 22 Aug 2014 06:39:00 +0000
Message-ID: <C4A61A5CA4AD2246942F4BA6F20ACB80435782FD@ALVA-EXMB04.alv.autoliv.int>
References: <20140626151424.GT32514@n2100.arm.linux.org.uk>
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
	<C4A61A5CA4AD2246942F4BA6F20ACB8043577770@ALVA-EXMB04.alv.autoliv.int>
	<53F11FF6.8030303@gmail.com>
	<CAOMZO5CDvQDD7gVLFStwv4MPrUyqZE3sEDZwb0gukkXujYG-6Q@mail.gmail.com>
	<53F2E89B.80009@gmail.com>	<53F5BE3D.5070209@gmail.com>
 <CAOMZO5A3CgaVCKxNDG-zEdwprYdRDXD_XZ2ikW+mns-iieYHsg@mail.gmail.com>
In-Reply-To: <CAOMZO5A3CgaVCKxNDG-zEdwprYdRDXD_XZ2ikW+mns-iieYHsg@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s7M6dD8t011090

Fabio,

> What is the silicon version of the mx6 in your sabrelite? What GCC version do
> you use?

The silicon version is PCIMX6Q6AVT10AA and the GCC version we use is
arm-none-eabi-gcc (Fedora 2013.11.24-2.fc19) 4.8.1.

Iain,

> Up to now, my testing has been done with my own config, I'll now
> repeat the whole thing using the config Mattis posted to see if I can
> reproduce it that way.

Thanks for testing this. Could you also send me the config that you used for
your Sabrelite?

Do you know of any options that enable additional debug information about
the network driver state (full buffers etc.)?

Best regards,
Mattis Lorentzon

***************************************************************
Consider the environment before printing this message.

To read Autoliv's Information and Confidentiality Notice, follow this link:
http://www.autoliv.com/disclaimer.html
***************************************************************ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
