Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab3AOKhV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 05:37:21 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:51957 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756800Ab3AOKhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 05:37:17 -0500
From: "Kumar, Anil" <anilkumar.v@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@deeprootsystems.com>, "hs@denx.de" <hs@denx.de>
Subject: RE: [PATCH V2 3/3] ARM: davinci: da850: add NAND driver entries
Thread-Topic: [PATCH V2 3/3] ARM: davinci: da850: add NAND driver entries
Thread-Index: AQHN7XjyHRW1+KNxCk+Xv+44IjJmqJhAl+YAgAGAZICAAAn3gIAIGXAw
Date: Tue, 15 Jan 2013 10:36:55 +0000
Message-ID: <F3DBB1B3EF102E4994C89758CFCA32412B96F9@DBDE01.ent.ti.com>
References: <1357633220-29827-1-git-send-email-anilkumar.v@ti.com>
 <1357633220-29827-4-git-send-email-anilkumar.v@ti.com>
 <50ED66F2.8050006@ti.com>
 <F3DBB1B3EF102E4994C89758CFCA32412B80CA@DBDE01.ent.ti.com>
 <50EEB1C1.9060306@ti.com>
In-Reply-To: <50EEB1C1.9060306@ti.com>
Accept-Language: en-US
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0FAbhSS007403

On Thu, Jan 10, 2013 at 17:49:13, Nori, Sekhar wrote:
> On 1/10/2013 1:07 PM, Kumar, Anil wrote:
> > On Wed, Jan 09, 2013 at 18:17:46, Nori, Sekhar wrote:
> 
> > I do not think that it is good idea to move NAND pin mux information
> > into da850.dtsi because this information is evm specific.
> > if we will use this approach then we must use the same approach for
> > other modules also as ASoC etc.   
> 
> Why do you consider this EVM specific. IOW, which pins do you see
> changing on another board? BTW, if there are additional pins needed than
> what are listed, we can always add more pinux entries in the .dts files.
> The pins present in dtsi file should the base case.
 
Ok, we can use this approach for DaVinci as its SoC modules do not
have multiple pin configuration option. I will do the changes in 
next patch series.

Thanks,
Anil
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
