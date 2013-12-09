Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761364Ab3LIRGm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 12:06:42 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:44891 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab3LIRGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 12:06:35 -0500
Date: Mon, 9 Dec 2013 17:06:17 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "patches@linaro.org" <patches@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Linaro-acpi] [RFC part1 PATCH 1/7] ACPI: Make ACPI core
 running without PCI on ARM64
Message-ID: <20131209170617.GC30717@srcf.ucam.org>
References: <1386088611-2801-1-git-send-email-hanjun.guo@linaro.org>
 <20131209115050.GA19163@arm.com>
 <52A5C024.5050702@linaro.org>
 <201312091735.05014.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201312091735.05014.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 05:35:04PM +0100, Arnd Bergmann wrote:

> Exactly. In particular we don't want people to get the wrong idea about
> where we are heading, so making it possible to use this code on embedded
> systems for me is a reason *not* to take the patch.

People are trying to deploy ACPI-based embedded x86, and most of the 
ACPI/DT integration discussion seems to have been based on the idea that 
this is a worthwhile thing to support. If we're not interested in doing 
so then we should probably make that a whole kernel decision rather than 
a per architecture one.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
