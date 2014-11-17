Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbaKQCjI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 21:39:08 -0500
Received: from cnbjrel02.sonyericsson.com ([219.141.167.166]:7593 "EHLO
	cnbjrel02.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752141AbaKQCjG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 21:39:06 -0500
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>
CC: "'Will Deacon'" <will.deacon@arm.com>,
        "'Ard Biesheuvel'" <ard.biesheuvel@linaro.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'akinobu.mita@gmail.com'" <akinobu.mita@gmail.com>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'Joe Perches'" <joe@perches.com>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Date: Mon, 17 Nov 2014 10:38:58 +0800
Subject: RE: [RFC V6 2/3] arm:add bitrev.h file to support rbit instruction
Thread-Topic: [RFC V6 2/3] arm:add bitrev.h file to support rbit instruction
Thread-Index: Ac//8Y3gfHXz4vZxRTGitDF3ewZNIwCHdBrw
Message-ID: <35FD53F367049845BC99AC72306C23D103E688B313C6@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D103E010D18265@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18266@CNBJMBX05.corpusers.net>
 <20141030120127.GC32589@arm.com>
 <CAKv+Gu9g5Q6fjPUy+P8YxkeDrH+bdO4kKGnxTQZRFhQpgPxaPA@mail.gmail.com>
 <20141030135749.GE32589@arm.com>
 <35FD53F367049845BC99AC72306C23D103E010D18272@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18273@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18275@CNBJMBX05.corpusers.net>
 <20141113235322.GC4042@n2100.arm.linux.org.uk>
 <35FD53F367049845BC99AC72306C23D103E010D1829B@CNBJMBX05.corpusers.net>
 <20141114095812.GG4042@n2100.arm.linux.org.uk>
In-Reply-To: <20141114095812.GG4042@n2100.arm.linux.org.uk>
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

> From: Russell King - ARM Linux [mailto:linux@arm.linux.org.uk]
> Sent: Friday, November 14, 2014 5:58 PM
> To: Wang, Yalin
> Cc: 'Will Deacon'; 'Ard Biesheuvel'; 'linux-kernel@vger.kernel.org';
> 'akinobu.mita@gmail.com'; 'linux-mm@kvack.org'; 'Joe Perches'; 'linux-arm-
> kernel@lists.infradead.org'
> Subject: Re: [RFC V6 2/3] arm:add bitrev.h file to support rbit instruction
>
> > Is it possible to build a kernel that support both CPU_V6 and CPU_V7?
> 
> Absolutely it is.
> 
> > I mean in Kconfig, CPU_V6 = y and CPU_V7 = y ?
> 
> Yes.
> 
> > If there is problem like you said,
> > How about this solution:
> > select HAVE_ARCH_BITREVERSE if ((CPU_V7M || CPU_V7) && !CPU_V6)
> 
> That would work.
> 
OK, I will submit a patch for this change.

> > For this patch,
> > I just cherry-pick from Joe,
> > If you are not responsible for this part, I will submit to the
> > maintainers for these patches .
> > Sorry for that .
> 
> I think you need to discuss with Joe how Joe would like his patches handled.
> However, it seems that Joe already sent his patches to the appropriate
> maintainers, and they have been applying those patches themselves.
> 
> Since your generic ARM changes depend on these patches being accepted first,
> this means is that I can't apply the generic ARM changes until those other
> patches have hit mainline, otherwise things are going to break.  So, when
> you come to submit the latest set of patches to the patch system, please do
> so only after these dependent patches have been merged into mainline so
> that they don't get accidentally applied before hand and break the two
> drivers that Joe mentioned.

Joe has submitted patches to maintainers,
So we need wait for them to be accepted .

Thanks

