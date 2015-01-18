Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbbARGqt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 01:46:49 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:37411 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbbARGqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 01:46:46 -0500
Message-ID: <54BB56CB.7040701@linaro.org>
Date: Sun, 18 Jan 2015 14:46:35 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jon Masters <jcm@redhat.com>
CC: Randy Dunlap <rdunlap@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>, Olof Johansson <olof@lixom.net>,
        "wangyijing@huawei.com" <wangyijing@huawei.com>,
        Robert Richter <rric@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "phoenix.liyi@huawei.com" <phoenix.liyi@huawei.com>,
        Rob Herring <robh@kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Mark Rutland <Mark.Rutland@arm.com>, Timur Tabi <timur@codeaurora.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH v7 06/17] ARM64 / ACPI: Make PCI optional for ACPI on
 ARM64
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org> <1421247905-3749-7-git-send-email-hanjun.guo@linaro.org> <20150116094913.GA13634@e104818-lin.cambridge.arm.com> <54BB51F1.8000900@linaro.org> <508480149.12941388.1421562696311.JavaMail.zimbra@zmail15.collab.prod.int.phx2.redhat.com>
In-Reply-To: <508480149.12941388.1421562696311.JavaMail.zimbra@zmail15.collab.prod.int.phx2.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015年01月18日 14:31, Jon Masters wrote:
> Hi Folks,
>
> Sorry for top posting from bed. The mainstream servers will all likely do
 > PCIe but there are several that may not. They should not be excluded. 
That said,
 >if we booted a previously built kernel on a system without an MCFG and
 > got no ECAM/root then things would probably still work.
>
> I think it'll work out either way but for the record there is no requirement to do PCIe on ARM servers that conform to spec.

OK, Catalin already said that was not the main point of the
comments for this patch, I think the title and change log
of the patch is inconsistent with the code makes Catalin confused,
I will update them in next version.

Thanks
Hanjun
