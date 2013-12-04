Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562Ab3LDOJE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 09:09:04 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:51855 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932506Ab3LDOJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 09:09:01 -0500
Message-ID: <529F376F.8050005@linaro.org>
Date: Wed, 04 Dec 2013 22:08:47 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Jon Masters <jonathan@jonmasters.org>, patches@linaro.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        linaro-acpi@lists.linaro.org,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Al Stone <al.stone@linaro.org>
Subject: Re: [RFC part1 PATCH 1/7] ACPI: Make ACPI core running without PCI
 on ARM64
References: <1386088611-2801-1-git-send-email-hanjun.guo@linaro.org> <1386088611-2801-2-git-send-email-hanjun.guo@linaro.org> <20131203164111.GA13447@srcf.ucam.org>
In-Reply-To: <20131203164111.GA13447@srcf.ucam.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年12月04日 00:41, Matthew Garrett wrote:
> Given the number of #ifdefs you're adding, wouldn't it make more sense
> to just add stub functions to include/linux/pci.h?

Thanks for the suggestion :)

I can add stub functions in include/linux/pci.h for raw_pci_read()/
raw_pci_write(), then can remove #ifdefs for acpi_os_read/write_pci_configuration().

Thanks
Hanjun

>

