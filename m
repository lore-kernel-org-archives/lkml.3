Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbaIAR3e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 13:29:34 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:23671 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751082AbaIAR3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 13:29:31 -0400
Date: Mon, 1 Sep 2014 18:29:24 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Graeme Gregory <gg@slimlogic.co.uk>
Cc: "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sudeep Holla <Sudeep.Holla@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>
Subject: Re: [RFC PATCH for Juno 2/2] tty: SBSA compatible UART
Message-ID: <20140901172924.GJ608@arm.com>
References: <1409583961-7466-1-git-send-email-hanjun.guo@linaro.org>
 <1409583961-7466-3-git-send-email-hanjun.guo@linaro.org>
 <20140901171248.GG608@arm.com>
 <20140901171856.GL2953@xora-haswell.xora.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140901171856.GL2953@xora-haswell.xora.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 06:18:56PM +0100, Graeme Gregory wrote:
> On Mon, Sep 01, 2014 at 06:12:48PM +0100, Catalin Marinas wrote:
> > On Mon, Sep 01, 2014 at 04:06:01PM +0100, Hanjun Guo wrote:
> > > From: Graeme Gregory <graeme.gregory@linaro.org>
> > > 
> > > This is a subset of pl011 UART which does not supprt DMA or baud rate
> > > changing.
> > > 
> > > It is specified in the Server Base System Architecture document from
> > > ARM.
> > > 
> > > Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
> > > ---
> > >  drivers/tty/Kconfig    |    6 +
> > >  drivers/tty/Makefile   |    1 +
> > >  drivers/tty/sbsauart.c |  328 ++++++++++++++++++++++++++++++++++++++++++++++++
> > >  3 files changed, 335 insertions(+)
> > >  create mode 100644 drivers/tty/sbsauart.c
> > 
> > Any overlap with this?
> > 
> > http://www.spinics.net/lists/arm-kernel/msg358084.html
> > 
> I knew that driver was being developed and is why we specifically said
> we did not plan to upstream this in preference for ARMs version.
> 
> I just missed the release of this 2 days ago.

Thanks. Please give feedback to Andre when you had the chance to look at
it.

-- 
Catalin
