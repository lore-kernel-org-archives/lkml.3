Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298AbaIRXBV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 19:01:21 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:57799 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750705AbaIRXBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 19:01:18 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Graeme Gregory <gg@slimlogic.co.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, Graeme Gregory <graeme.gregory@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Will Deacon <will.deacon@arm.com>, linaro-acpi@lists.linaro.org,
        Liviu Dudau <Liviu.Dudau@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>, linux-acpi@vger.kernel.org,
        Charles.Garcia-Tobin@arm.com, Robert Richter <rric@kernel.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>, Jon Masters <jcm@redhat.com>,
        Mark Brown <broonie@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        Sudeep Holla <Sudeep.Holla@arm.com>
Subject: Re: [PATCH v4 18/18] Documentation: ACPI for ARM64
Date: Fri, 19 Sep 2014 01:20:52 +0200
Message-ID: <6318202.hl003vettj@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140917234036.GC2464@xora-yoga-13>
References: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org> <201409180122.10631.arnd@arndb.de> <20140917234036.GC2464@xora-yoga-13>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 17, 2014 04:40:36 PM Graeme Gregory wrote:
> On Thu, Sep 18, 2014 at 01:22:10AM +0200, Arnd Bergmann wrote:
> > On Wednesday 17 September 2014, Graeme Gregory wrote:
> > > It sounds like from the discussions in other threads that ARM64 should
> > > be following x86 and re-using DT bindings here. In which case there is
> > > not need to submit things to UEFI organisation.
> > > 
> > > What I got a little lost in has there been a formal decision about DT
> > > bindings in _DSD?
> > 
> > I think this is a discussion that still needs to happen: either we should
> > recommend everyone to use _DSD in favor of the alternatives, or we
> > should prohibit the use of _DSD. I have heard arguments both ways, but
> > hopefully we can find an easy answer.
> > 
> 
> This discussion is just not going to happen until people at @redhat.com
> and people who have currently announced/released hardware are actually
> willing to start talking about it.
> 
> Id love to be able to put my foot down and ban the use of _DSD for
> servers but I suspect that will not happen.

I'll probably should stay away from this discussion, but I can't resist. :-)

Please imagine the situation in which the same IP block is included in an ARM64
SoC and in an x86 SoC that ships with ACPI tables and a _DSD for that device in
them.  What benefit would be there from disallowing systems based on the ARM64
SoC in question to ship the same _DSD in their ACPI tables?

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
