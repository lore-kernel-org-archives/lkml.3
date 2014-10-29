Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbaJ2FUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 01:20:21 -0400
Received: from cnbjrel02.sonyericsson.com ([219.141.167.166]:18444 "EHLO
	cnbjrel02.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751165AbaJ2FUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 01:20:20 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Rob Herring'" <robherring2@gmail.com>, Joe Perches <joe@perches.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akinobu.mita@gmail.com" <akinobu.mita@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Wed, 29 Oct 2014 13:20:14 +0800
Subject: RE: [RFC V2] arm/arm64:add CONFIG_HAVE_ARCH_BITREVERSE to support
 rbit instruction
Thread-Topic: [RFC V2] arm/arm64:add CONFIG_HAVE_ARCH_BITREVERSE to support
 rbit instruction
Thread-Index: Ac/zKGffEmlPWtUCT7yIK/xKLtVDxQAD4w/w
Message-ID: <35FD53F367049845BC99AC72306C23D103E010D18262@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D103E010D18254@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18257@CNBJMBX05.corpusers.net>
 <1414392371.8884.2.camel@perches.com>
 <CAL_JsqJYBoG+nrr7R3UWz1wrZ--Xjw5X31RkpCrTWMJAePBgRg@mail.gmail.com>
In-Reply-To: <CAL_JsqJYBoG+nrr7R3UWz1wrZ--Xjw5X31RkpCrTWMJAePBgRg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9T5KSpK032472

> From: Rob Herring [mailto:robherring2@gmail.com]
> >> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig index
> >> 9532f8d..263c28c 100644
> >> --- a/arch/arm64/Kconfig
> >> +++ b/arch/arm64/Kconfig
> >> @@ -36,6 +36,7 @@ config ARM64
> >>       select HARDIRQS_SW_RESEND
> >>       select HAVE_ARCH_AUDITSYSCALL
> >>       select HAVE_ARCH_JUMP_LABEL
> >> +     select HAVE_ARCH_BITREVERSE
> >>       select HAVE_ARCH_KGDB
> >>       select HAVE_ARCH_TRACEHOOK
> >>       select HAVE_BPF_JIT
> 
> The kconfig lists should be sorted.
> 
> Rob

Got it ,
Thanks for your remind.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
