Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760124AbbA1V3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:29:23 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:45498 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933423AbbA1Urx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:47:53 -0500
Message-ID: <54C92804.5090806@codeaurora.org>
Date: Wed, 28 Jan 2015 12:18:44 -0600
From: Timur Tabi <timur@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        "wangyijing@huawei.com" <wangyijing@huawei.com>,
        Rob Herring <robh@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "phoenix.liyi@huawei.com" <phoenix.liyi@huawei.com>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        Mark Brown <broonie@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [Linaro-acpi] [PATCH v7 04/17] ARM64 / ACPI: Introduce early_param
 for "acpi" and pass acpi=force to enable ACPI
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org> <1421247905-3749-5-git-send-email-hanjun.guo@linaro.org> <CAOZdJXU2bFR1T4ZnGavvnrUXAp5e=vNt9g6WKX46H8qs1wz-TQ@mail.gmail.com> <CAOZdJXXe+29rux1L3QYBX0yHLy3kdi+ZJrXVd=XfgYN=R6DtKA@mail.gmail.com> <20150128181453.GG31752@e104818-lin.cambridge.arm.com>
In-Reply-To: <20150128181453.GG31752@e104818-lin.cambridge.arm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2015 12:14 PM, Catalin Marinas wrote:
>> >So it looks like there's a whole conversation about this already in
>> >this thread that I didn't notice.  However, reading through all of it,
>> >I still don't understand sure why the presence of ACPI tables is
>> >insufficient to enable ACPI.

> Because ACPI on arm64 is still experimental, no matter how many people
> claim that it is production ready in their private setups.

Fair enough.  Does this mean that passing "acpi=force" on the kernel 
command line is a requirement for ARM64 servers?

>> >In what situation would we want to ignore ACPI tables that are
>> >present?

> When DT tables are also present (and for the first platforms, that's
> highly recommended, though not easily enforceable at the kernel level).

My understanding is that the EFI stub creates a device tree (and it 
contains some important information), so I don't understand how we can 
ever have an ACPI-only platform on ARM64 servers.

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
