Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734AbaIQTvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 15:51:37 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:55011 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756231AbaIQTvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 15:51:36 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Hanjun Guo <hanjun.guo@linaro.org>,
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
        Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>,
        Marc Zyngier <marc.zyngier@arm.com>, Jon Masters <jcm@redhat.com>,
        Mark Brown <broonie@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH v4 18/18] Documentation: ACPI for ARM64
Date: Wed, 17 Sep 2014 22:11:13 +0200
Message-ID: <1628662.T2ReQ4irMm@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140917192259.GA18980@srcf.ucam.org>
References: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org> <4416582.iOjLNrLDZE@vostro.rjw.lan> <20140917192259.GA18980@srcf.ucam.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 17, 2014 08:22:59 PM Matthew Garrett wrote:
> On Wed, Sep 17, 2014 at 09:37:42PM +0200, Rafael J. Wysocki wrote:
> 
> > There are no implied IP issues with using the information there I know of and
> > if there's any fine print anywhere that may suggest so, please let me know.
> 
> Using the information should be fine, but my understanding of the UEFI 
> forum rules is that any submissions to UEFI specs must be from UEFI 
> forum members - there are concerns around accidentally including 
> patented material.

The documents in question are not regarded as UEFI specs, however.  They
are just hosted by UEFI.

> The easy way around this is just for the bindings to 
> be managed outside UEFI.

Again, there's a difference between UEFI material and the UEFI hosting
something (but not maintaining it).

In principle, the bindings could be hosted by UEFI, but maintained by
community members.

Rafael

