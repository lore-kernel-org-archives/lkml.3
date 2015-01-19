Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412AbbASQF5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 11:05:57 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:57414 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbbASQFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 11:05:55 -0500
Message-ID: <3d2bf89730cd9c1354cedfbb429ae3a9.squirrel@www.codeaurora.org>
Date: Mon, 19 Jan 2015 16:05:54 -0000
Subject: Re: [Linaro-acpi] [PATCH v7 17/17] Documentation: ACPI for ARM64
From: ashwinc@codeaurora.org
To: "Hanjun Guo" <hanjun.guo@linaro.org>
Cc: ashwinc@codeaurora.org, "Catalin Marinas" <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Olof Johansson" <olof@lixom.net>, "Arnd Bergmann" <arnd@arndb.de>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Grant Likely" <grant.likely@linaro.org>,
        "Will Deacon" <will.deacon@arm.com>, "Rob Herring" <robh@kernel.org>,
        "Robert Richter" <rric@kernel.org>,
        "Jason Cooper" <jason@lakedaemon.net>,
        "linux acpi" <linux-acpi@vger.kernel.org>,
        "Marc Zyngier" <marc.zyngier@arm.com>, "Jon Masters" <jcm@redhat.com>,
        "Timur Tabi" <timur@codeaurora.org>,
        "Randy Dunlap" <rdunlap@infradead.org>,
        "lkml" <linux-kernel@vger.kernel.org>,
        "Linaro ACPI Mailman List" <linaro-acpi@lists.linaro.org>,
        "Yijing Wang" <wangyijing@huawei.com>,
        "Mark Brown" <broonie@kernel.org>,
        "Bjorn Helgaas" <bhelgaas@google.com>,
        "Yi Li" <phoenix.liyi@huawei.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
User-Agent: SquirrelMail/1.4.22-4.el6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hanjun,

> ---------- Forwarded message ----------
> From: Hanjun Guo <hanjun.guo@linaro.org>
> Date: 14 January 2015 at 10:05
> Subject: [Linaro-acpi] [PATCH v7 17/17] Documentation: ACPI for ARM64
From: Graeme Gregory <graeme.gregory@linaro.org>
> Add documentation for the guidelines of how to use ACPI
> on ARM64.
> Reviewed-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Reviewed-by: Yi Li <phoenix.liyi@huawei.com>
> Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
> Signed-off-by: Al Stone <al.stone@linaro.org>
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> ---
>  Documentation/arm64/arm-acpi.txt | 327
> +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 327 insertions(+)
>  create mode 100644 Documentation/arm64/arm-acpi.txt

Thanks for including previous feedback. This version looks good to us.
Reviewed-by: Ashwin Chaugule <ashwinc@codeaurora.org>

Sign-offs on the other patches in this series should follow shortly.

Thanks,
Ashwin

--
Qualcomm Innovation Center, Inc
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

--




