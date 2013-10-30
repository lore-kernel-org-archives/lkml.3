Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab3J3VSd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 17:18:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:25425 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924Ab3J3VSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 17:18:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,604,1378882800"; 
   d="scan'208";a="425421261"
Message-ID: <1383142680.2460.5.camel@dvhart-mobl4.amr.corp.intel.com>
Subject: Re: [PATCH 4/8] minnowboard: Add base platform driver for the
 MinnowBoard
From: Darren Hart <dvhart@linux.intel.com>
To: Mark Brown <broonie@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "peter.p.waskiewicz.jr" <peter.p.waskiewicz.jr@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        danders <danders@circuitco.com>,
        "vishal.l.verma" <vishal.l.verma@intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Grant Likely <grant.likely@linaro.org>,
        Richard Purdie <richard.purdie@linuxfoundation.org>,
        platform-driver-x86 <platform-driver-x86@vger.kernel.org>
In-Reply-To: <20130721234134.GA9858@sirena.org.uk>
References: <cover.1372211451.git.dvhart@linux.intel.com>
	 <a459c0b97ea41148af901fc73dbeff98778c7419.1372211451.git.dvhart@linux.intel.com>
	 <CACRpkda8QGdoAvjsUs7Uu+ukUu7ST63g=H9arA7SS7ceWmMTaQ@mail.gmail.com>
	 <1372398218.9243.29.camel@envy.home> <20130704162641.GG27646@sirena.org.uk>
	 <CACRpkdbKGti==FTfHm81EkwD++iRfixnXt3kWgBj7CxjM+2znA@mail.gmail.com>
	 <20130721234134.GA9858@sirena.org.uk>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Oct 2013 14:18:00 +0000
Mime-Version: 1.0
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-22 at 00:41 +0100, Mark Brown wrote:
> On Sat, Jul 20, 2013 at 07:37:54PM +0200, Linus Walleij wrote:
> > On Thu, Jul 4, 2013 at 6:26 PM, Mark Brown <broonie@kernel.org> wrote:
> 
> > > We should really have a subsystem for this too - the general idea idea
> > > of identifying boards, fit options and so on by looking at things like
> > > GPIOs or numbers in flash is really common.
> 
> > Would it then be a bus following the pattern we chiseled out for
> > the soc bus? (Greg, Lee & Arnd architectured this.)
> 
> I'd expect it to be a bus, yes.

It seems to me the platform bus already provides everything we need. We
can just make a platform driver, say platform-id-gpio.c which can get
it's platform data from OF or ACPI (_PRP proposal from kernel summit
last week for example). Why would a separate bus type need to be
defined?

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel


