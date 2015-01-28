Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759278AbbA2Fhn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 00:37:43 -0500
Received: from 2.mo6.mail-out.ovh.net ([46.105.76.65]:40113 "EHLO
	2.mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278AbbA2Fhm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 00:37:42 -0500
X-Greylist: delayed 32128 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Jan 2015 00:37:42 EST
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: [PATCH] ARM: /proc/atags: Export also for DT
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
In-Reply-To: <20150128071950.GB29927@amd>
Date: Wed, 28 Jan 2015 16:06:17 +0800
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Tony Lindgren <tony@atomide.com>, Sebastian Reichel <sre@debian.org>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?utf-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <F2E2E152-2054-4284-9DAC-67FEC30DF399@jcrosoft.com>
References: <20150127132127.GA869@amd> <CAL_JsqKM+2PtX_EpWXyOQHVXwf=jqVj8SroUGPO1Y2=Zj8_kMg@mail.gmail.com> <201501271532.25540@pali> <20150127174818.GM26493@n2100.arm.linux.org.uk> <alpine.LFD.2.11.1501271446330.1322@knanqh.ubzr> <20150127210943.GN26493@n2100.arm.linux.org.uk> <alpine.LFD.2.11.1501271614280.1322@knanqh.ubzr> <20150127223331.GP26493@n2100.arm.linux.org.uk> <alpine.LFD.2.11.1501272027390.1322@knanqh.ubzr> <1FECE32B-0D63-4696-BED7-74FE5845C260@jcrosoft.com> <20150128071950.GB29927@amd>
To: Pavel Machek <pavel@ucw.cz>
X-Mailer: Apple Mail (2.1993)
X-Ovh-Tracer-Id: 10988220141245868883
X-Ovh-Remote: 80.15.34.121 (lmontsouris-656-1-34-121.w80-15.abo.wanadoo.fr)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -51
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejkedrvdejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenogfuuhhsphgvtghtffhomhgrihhnucdlgeelmd
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -51
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejkedrvdejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenogfuuhhsphgvtghtffhomhgrihhnucdlgeelmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Jan 28, 2015, at 3:19 PM, Pavel Machek <pavel@ucw.cz> wrote:
> 
> Hi!
> 
>>> In other words, what prevents someone from creating, say, a custom 
>>> minimal Barebox version that sits on top of the existing N900 
>>> bootloader?  Wouldn't that provide a much better user experience?
>> 
>> I do agree with Nicolas
>> 
>> If I can get my hand on a phone I’ll put barebox on it
> 
> Grab it in the nearest "second hand cellphones" shop, and have fun! It
> should be less than $70.

will see if I can found one in Shanghai at the second hand market

Does it exist a qemu emulation?

Best Regards,
J.
> 									Pavel
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

