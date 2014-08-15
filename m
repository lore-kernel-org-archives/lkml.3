Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751404AbaHOWnN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 18:43:13 -0400
Received: from mail-yk0-f181.google.com ([209.85.160.181]:49260 "EHLO
	mail-yk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaHOWnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 18:43:11 -0400
MIME-Version: 1.0
In-Reply-To: <1406206825-15590-20-git-send-email-hanjun.guo@linaro.org>
References: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org>
	<1406206825-15590-20-git-send-email-hanjun.guo@linaro.org>
Date: Fri, 15 Aug 2014 18:43:10 -0400
X-Google-Sender-Auth: Pe0Wev12Sa0V1S8Krqjf7Bt4_XA
Message-ID: <CAJvTdKnTLtozLZnAJcgZODV9-D77u3=hK3d7z-5XCZZTFwhqOg@mail.gmail.com>
Subject: Re: [PATCH 19/19] Documentation: ACPI for ARM64
From: Len Brown <lenb@kernel.org>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Will Deacon <will.deacon@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@linaro.org>, Robert Richter <rric@kernel.org>,
        Lv Zheng <lv.zheng@intel.com>, Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        linux acpi <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linaro-acpi-private@linaro.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Additional driver specific
> +data should be passed in the appropriate _DSM (ACPI Section 9.14.1) method or
> +_DSD (ACPI Section 6.2.5).

Re: _DSD

Yes.

Re: _DSM

No, not if it can be handled by _DSD.

cheers,
Len Brown, Intel Open Source Technology Center
