Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910AbaKCCRZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 21:17:25 -0500
Received: from cnbjrel02.sonyericsson.com ([219.141.167.166]:2702 "EHLO
	cnbjrel02.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752138AbaKCCRX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 21:17:23 -0500
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Will Deacon'" <will.deacon@arm.com>
CC: "'Ard Biesheuvel'" <ard.biesheuvel@linaro.org>,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'akinobu.mita@gmail.com'" <akinobu.mita@gmail.com>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'Joe Perches'" <joe@perches.com>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Date: Mon, 3 Nov 2014 10:17:15 +0800
Subject: RE: [RFC V6 3/3] arm64:add bitrev.h file to support rbit instruction
Thread-Topic: [RFC V6 3/3] arm64:add bitrev.h file to support rbit
 instruction
Thread-Index: Ac/093pf+266lKYFRgKWSwcrgci7HgCFELlg
Message-ID: <35FD53F367049845BC99AC72306C23D103E010D18287@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D103E010D18260@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18261@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18264@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18265@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18266@CNBJMBX05.corpusers.net>
 <20141030120127.GC32589@arm.com>
 <CAKv+Gu9g5Q6fjPUy+P8YxkeDrH+bdO4kKGnxTQZRFhQpgPxaPA@mail.gmail.com>
 <20141030135749.GE32589@arm.com>
 <35FD53F367049845BC99AC72306C23D103E010D18272@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18274@CNBJMBX05.corpusers.net>
 <20141031104305.GC6731@arm.com>
In-Reply-To: <20141031104305.GC6731@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Will Deacon [mailto:will.deacon@arm.com]
> > +#ifndef __ASM_ARM64_BITREV_H
> > +#define __ASM_ARM64_BITREV_H
> 
> Really minor nit, but we don't tend to include 'ARM64' in our header guards,
> so this should just be __ASM_BITREV_H.
> 
> With that change,
> 
>   Acked-by: Will Deacon <will.deacon@arm.com>
> 
I have send the patch to the patch system:
http://www.arm.linux.org.uk/developer/patches/search.php?uid=4025

8187/1 8188/1 8189/1

Just remind you that , should also cherry-pick Joe Perches's 
2 patches:
[PATCH] 6fire: Convert byte_rev_table uses to bitrev8
[PATCH] carl9170: Convert byte_rev_table uses to bitrev8

To make sure there is no build error when build these 2 drivers.

Thanks
