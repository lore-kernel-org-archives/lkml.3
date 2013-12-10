Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184Ab3LJJ4I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:56:08 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:57707 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab3LJJ4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:56:03 -0500
MIME-Version: 1.0
In-Reply-To: <20131209170617.GC30717@srcf.ucam.org>
References: <1386088611-2801-1-git-send-email-hanjun.guo@linaro.org>
	<20131209115050.GA19163@arm.com>
	<52A5C024.5050702@linaro.org>
	<201312091735.05014.arnd@arndb.de>
	<20131209170617.GC30717@srcf.ucam.org>
Date: Tue, 10 Dec 2013 10:56:02 +0100
Message-ID: <CACRpkdYyiLAGerKuOjYO2eGz7cEWvy=SjD5Z1fo_0yU6Uwy7tA@mail.gmail.com>
Subject: Re: [Linaro-acpi] [RFC part1 PATCH 1/7] ACPI: Make ACPI core running
 without PCI on ARM64
From: Linus Walleij <linus.walleij@linaro.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "patches@linaro.org" <patches@linaro.org>,
        Olof Johansson <olof@lixom.net>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 9, 2013 at 6:06 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Mon, Dec 09, 2013 at 05:35:04PM +0100, Arnd Bergmann wrote:
>
>> Exactly. In particular we don't want people to get the wrong idea about
>> where we are heading, so making it possible to use this code on embedded
>> systems for me is a reason *not* to take the patch.
>
> People are trying to deploy ACPI-based embedded x86, and most of the
> ACPI/DT integration discussion seems to have been based on the idea that
> this is a worthwhile thing to support.

I have only seen Intel doing this, are there more people doing that?

As noted on patch [0/7] I still get patches for embedded x86 which
use ISA-style probing for embedded x86, e.g:
http://marc.info/?l=linux-gpio&m=138559852307673&w=2

At the same time some people are refining SFI (simple firmware
interface) support for GPIO, albeit I think that was for elder
embedded x86'es.

Yours,
Linus Walleij
