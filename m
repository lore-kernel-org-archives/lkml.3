Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab3LHCpl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 21:45:41 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:56275 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab3LHCpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 21:45:39 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC part1 PATCH 0/7] Make ACPI core running on ARM64
Date: Sun, 8 Dec 2013 03:44:56 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, linaro-kernel@lists.linaro.org,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        patches@linaro.org, Olof Johansson <olof@lixom.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>, linaro-acpi@lists.linaro.org,
        linux-acpi@vger.kernel.org, Hanjun Guo <hanjun.guo@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jon Masters <jonathan@jonmasters.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>
References: <1386088611-2801-1-git-send-email-hanjun.guo@linaro.org> <201312052325.02603.arnd@arndb.de> <20131206135825.GG29268@sirena.org.uk>
In-Reply-To: <20131206135825.GG29268@sirena.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201312080344.56317.arnd@arndb.de>
X-Provags-ID: V02:K0:ko+30or7yw0cH9eh38qBENFgG4W2G6SzmH8mwSYos7A
 pfIHCWw/4b0c0QGc7a9Up9e3Uc9mvp2V/NWehQQsp/nxS2PJgg
 gxEAS090GrdSQ2a7qtUeCpbu6EPDmpqwW5DzQ+O5zlOrRfAFlo
 IznXoy30lBRuU1M7RKpqPboWIncxNXzIBEImYnrrFY4/mU6bqF
 kR3WddGp+vzykctP1rwGtHekcLnoDwXDpzm3VMGBPWL2QIJXAH
 abAzDId+WPAdoTMsl2lIa8X65cqKBAxXR/sH65Tyz4f8S0cyoW
 iyldR8FwqsDvFD9GcpMvGxkuaNMnlT8ftmfsJtrrsZDPE6XUsK
 pBHup7uL40rUSvlGxqag=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 December 2013, Mark Brown wrote:
> On Thu, Dec 05, 2013 at 11:25:02PM +0100, Arnd Bergmann wrote:
> 
> > However, as I mentioned before I am much more worried about the parts that
> > are not done (or not posted) yet and that will be required to actually
> > have working support for a real server system. Until we know more about
> > where this is heading, I think we should not merge any of the ARM specific
> > parts of your patches. Any patches that are reasonable cleanups and bug
> > fixes for the ACPI subsystem should of course get merged once they are
> > reviewed.
> 
> OTOH if it's well encapsulated, is going to be required for any kind of
> ACPI use and gets to the point where people are OK with it by itself
> then I'm not sure what we'd gain by keeping it out of tree - it'd make
> the real system patch sets bigger and harder to review.

I'd agree as soon as someone can convince me that we actually want ACPI
support in the kernel for ARM64 servers. As far as I'm concerned it's quite
possible that the people who have worked on this for the past couple of
years behind closed doors know what they are doing and it will all be
good, but it's also possible that it turns into a huge trainwreck once
we see multiple implementations that have fundamentally incompatible
requirements regarding what they want from ACPI and we end up not doing
it at all. I just don't have enough information at this point to know which
of the two is true and I'd like to ensure that accepting the patches
that meet your criteria above would not be seen as an endorsement to do
crazy stuff later.

	Arnd
