Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbaAWQTb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 11:19:31 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:29503 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751407AbaAWQT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 11:19:29 -0500
Date: Thu, 23 Jan 2014 16:19:19 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Sudeep Holla <Sudeep.Holla@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        Al Stone <al.stone@linaro.org>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>
Subject: Re: [PATCH 03/20] ARM64 / ACPI: Introduce the skeleton of _PDC
 related for ARM64
Message-ID: <20140123161918.GA25927@localhost>
References: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org>
 <1389961514-13562-4-git-send-email-hanjun.guo@linaro.org>
 <52D93D4E.5020605@arm.com>
 <52DCEA66.90903@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52DCEA66.90903@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 09:20:38AM +0000, Hanjun Guo wrote:
> On 2014-1-17 22:25, Sudeep Holla wrote:
> > On 17/01/14 12:24, Hanjun Guo wrote:
> >> --- a/arch/arm64/kernel/process.c
> >> +++ b/arch/arm64/kernel/process.c
> >> @@ -89,6 +89,9 @@ void arch_cpu_idle_prepare(void)
> >>  	local_fiq_enable();
> >>  }
> >>  
> >> +unsigned long boot_option_idle_override = IDLE_NO_OVERRIDE;
> >> +EXPORT_SYMBOL(boot_option_idle_override);
> >> +
> > 
> > This is what I mentioned in other email. Do we really foresee use of this in
> > ARM64 or it's just added to avoid build issues ?
> 
> Just avoid build issues, can not foresee use of this in ARM64 :)

So ideally we should look for a better solution here.

-- 
Catalin
