Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347Ab3LCQyF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 11:54:05 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:53386 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815Ab3LCQyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 11:54:01 -0500
Date: Tue, 3 Dec 2013 16:53:18 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Jon Masters <jonathan@jonmasters.org>, patches@linaro.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        linaro-acpi@lists.linaro.org, Al Stone <al.stone@linaro.org>,
        Graeme Gregory <graeme.gregory@linaro.org>
Subject: Re: [RFC part1 PATCH 4/7] ARM64 / ACPI: Introduce the skeleton of
 _PDC related for ARM64
Message-ID: <20131203165318.2c04a8bf@alan.etchedpixels.co.uk>
In-Reply-To: <1386088611-2801-5-git-send-email-hanjun.guo@linaro.org>
References: <1386088611-2801-1-git-send-email-hanjun.guo@linaro.org>
	<1386088611-2801-5-git-send-email-hanjun.guo@linaro.org>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O> +enum idle_boot_override { IDLE_NO_OVERRIDE = 0, IDLE_HALT, IDLE_NOMWAIT,
> +			IDLE_POLL, IDLE_FORCE_MWAIT };

This should probably move out of the arch directory to be a single enum
including both platforms values. That will make it rather easier to keep
sane and avoid ifdefs around which definitions are for which processor.
