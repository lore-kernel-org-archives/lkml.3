Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180AbbAOSs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 13:48:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754076AbbAOSsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 13:48:55 -0500
Message-ID: <54B80B4F.6090303@redhat.com>
Date: Thu, 15 Jan 2015 12:47:43 -0600
From: Mark Langsdorf <mlangsdo@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Will Deacon <will.deacon@arm.com>
CC: Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Jon Masters <jcm@redhat.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh@kernel.org>, Robert Richter <rric@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        phoenix.liyi@huawei.com, Timur Tabi <timur@codeaurora.org>,
        suravee.suthikulpanit@amd.com, wangyijing@huawei.com,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: Re: [PATCH v7 09/17] ACPI / table: Print GIC information when MADT
 is parsed
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org> <1421247905-3749-10-git-send-email-hanjun.guo@linaro.org>
In-Reply-To: <1421247905-3749-10-git-send-email-hanjun.guo@linaro.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2015 09:04 AM, Hanjun Guo wrote:
> When MADT is parsed, print GIC information to make the boot
> log look pretty:
>
> ACPI: GICC (acpi_id[0x0000] address[00000000e112f000] MPIDR[0x0] enabled)
> ACPI: GICC (acpi_id[0x0001] address[00000000e112f000] MPIDR[0x1] enabled)
> ...
> ACPI: GICC (acpi_id[0x0201] address[00000000e112f000] MPIDR[0x201] enabled)
>
> These information will be very helpful to bring up early systems to
> see if acpi_id and MPIDR are matched or not as spec defined.
>
> Tested-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> Tested-by: Yijing Wang <wangyijing@huawei.com>
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
> ---
Tested-by: Mark Langsdorf <mlangsdo@redhat.com>
