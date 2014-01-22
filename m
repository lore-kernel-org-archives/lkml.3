Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbaAVOjD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 09:39:03 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:57506 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316AbaAVOi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 09:38:59 -0500
MIME-Version: 1.0
In-Reply-To: <20140122114537.GA15591@e106331-lin.cambridge.arm.com>
References: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org>
	<1389961514-13562-19-git-send-email-hanjun.guo@linaro.org>
	<CACRpkdYKwaH5DX27irzmcTDAMhQMUhuzz6N7mjKWv9tZchv0Ug@mail.gmail.com>
	<20140122114537.GA15591@e106331-lin.cambridge.arm.com>
Date: Wed, 22 Jan 2014 15:38:58 +0100
Message-ID: <CACRpkda1UoGV1anjZqPVXQU1+=xU3g3zpAvuu7C2sbhJgw+dSw@mail.gmail.com>
Subject: Re: [PATCH 18/20] clocksource / acpi: Add macro CLOCKSOURCE_ACPI_DECLARE
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Hanjun Guo <hanjun.guo@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Patch Tracking <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 12:45 PM, Mark Rutland <mark.rutland@arm.com> wrote:
> On Wed, Jan 22, 2014 at 08:26:50AM +0000, Linus Walleij wrote:

>> This hammers down the world to compile one binary for ACPI
>> and one binary for device tree. Maybe that's fine, I don't know.
>
> How does it do that?

Bah it doesn't I misread the patch. Forget that comment.

Yours,
Linus Walleij
