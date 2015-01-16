Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298AbbAPBrE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 20:47:04 -0500
Received: from cnbjrel02.sonyericsson.com ([219.141.167.166]:19203 "EHLO
	cnbjrel02.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752184AbbAPBrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 20:47:02 -0500
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>
CC: "'Ard Biesheuvel'" <ard.biesheuvel@linaro.org>,
        "'Will Deacon'" <will.deacon@arm.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'akinobu.mita@gmail.com'" <akinobu.mita@gmail.com>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'Joe Perches'" <joe@perches.com>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 16 Jan 2015 09:42:23 +0800
Subject: RE: [RFC V6 2/3] arm:add bitrev.h file to support rbit instruction
Thread-Topic: [RFC V6 2/3] arm:add bitrev.h file to support rbit instruction
Thread-Index: AdAwGH+GkFWyCyF6SCq88Q1ePFZX1QBFSNzw
Message-ID: <35FD53F367049845BC99AC72306C23D103EDAF89E1B0@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D103E010D18273@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18275@CNBJMBX05.corpusers.net>
 <20141113235322.GC4042@n2100.arm.linux.org.uk>
 <35FD53F367049845BC99AC72306C23D103E010D1829B@CNBJMBX05.corpusers.net>
 <20141114095812.GG4042@n2100.arm.linux.org.uk>
 <35FD53F367049845BC99AC72306C23D103E688B313C6@CNBJMBX05.corpusers.net>
 <20150108184059.GZ12302@n2100.arm.linux.org.uk>
 <35FD53F367049845BC99AC72306C23D103EDAF89E195@CNBJMBX05.corpusers.net>
 <20150109111048.GE12302@n2100.arm.linux.org.uk>
 <35FD53F367049845BC99AC72306C23D103EDAF89E198@CNBJMBX05.corpusers.net>
 <20150114163800.GZ12302@n2100.arm.linux.org.uk>
In-Reply-To: <20150114163800.GZ12302@n2100.arm.linux.org.uk>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0G1l9KO019220

> -----Original Message-----
> From: Russell King - ARM Linux [mailto:linux@arm.linux.org.uk]
> Sent: Thursday, January 15, 2015 12:38 AM
> To: Wang, Yalin
> Cc: 'Ard Biesheuvel'; 'Will Deacon'; 'linux-kernel@vger.kernel.org';
> 'akinobu.mita@gmail.com'; 'linux-mm@kvack.org'; 'Joe Perches'; 'linux-arm-
> kernel@lists.infradead.org'
> Subject: Re: [RFC V6 2/3] arm:add bitrev.h file to support rbit instruction
> 
> On Fri, Jan 09, 2015 at 08:40:56PM +0800, Wang, Yalin wrote:
> > Oh, I see,
> > How about change like this:
> > +	select HAVE_ARCH_BITREVERSE if ((CPU_V7M || CPU_V7) && !CPU_V6 &&
> > +!CPU_V6K)
> > I am not sure if I also need add some older CPU types like !CPU_ARM9TDMI
> &&ã€€!CPU_ARM940T ?
> >
> > Another solution is:
> > +	select HAVE_ARCH_BITREVERSE if ((CPU_32V7M || CPU_32V7) && !CPU_32V6
> > +&& !CPU_32V5 && !CPU_32V4 && !CPU_32V4T && !CPU_32V3)
> >
> > By the way, I am not clear about the difference between CPU_V6 and
> > CPU_V6K, could you tell me? :)
> 
> I think
> 
> 	select HAVE_ARCH_BITREVERSE if (CPU_32v7M || CPU_32v7) && !CPU_32v6
> 
> is sufficient - we don't support mixing pre-v6 and v6+ CPU architectures
> into a single kernel.
> 
Ok, I will re-send a patch. 

Thanks
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
