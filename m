Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741AbbASE0t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 23:26:49 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53330 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbbASE0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 23:26:45 -0500
Message-ID: <54BC876E.3040402@linaro.org>
Date: Mon, 19 Jan 2015 12:26:22 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Graeme Gregory <gg@slimlogic.co.uk>
CC: Jon Masters <jcm@redhat.com>, Mark Rutland <Mark.Rutland@arm.com>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "wangyijing@huawei.com" <wangyijing@huawei.com>,
        Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Timur Tabi <timur@codeaurora.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "phoenix.liyi@huawei.com" <phoenix.liyi@huawei.com>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <Marc.Zyngier@arm.com>,
        Mark Brown <broonie@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v7 06/17] ARM64 / ACPI: Make PCI optional for ACPI on
 ARM64
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org> <1421247905-3749-7-git-send-email-hanjun.guo@linaro.org> <20150116094913.GA13634@e104818-lin.cambridge.arm.com> <54BB51F1.8000900@linaro.org> <508480149.12941388.1421562696311.JavaMail.zimbra@zmail15.collab.prod.int.phx2.redhat.com> <54BB56CB.7040701@linaro.org> <20150118092955.GE6182@xora-haswell.xora.org.uk>
In-Reply-To: <20150118092955.GE6182@xora-haswell.xora.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015年01月18日 17:29, Graeme Gregory wrote:
> On Sun, Jan 18, 2015 at 02:46:35PM +0800, Hanjun Guo wrote:
>> On 2015年01月18日 14:31, Jon Masters wrote:
>>> Hi Folks,
>>>
>>> Sorry for top posting from bed. The mainstream servers will all likely do
>>> PCIe but there are several that may not. They should not be excluded. That
>> said,
>>> if we booted a previously built kernel on a system without an MCFG and
>>> got no ECAM/root then things would probably still work.
>>>
>>> I think it'll work out either way but for the record there is no requirement to do PCIe on ARM servers that conform to spec.
>>
>> OK, Catalin already said that was not the main point of the
>> comments for this patch, I think the title and change log
>> of the patch is inconsistent with the code makes Catalin confused,
>> I will update them in next version.
>>
> Well what we are talking about is the presence of CONFIG_PCI=y which even
> in Jons case will be true as he wants to run the same kernel on both
> sets of hardware.
>
> Now the architecture has PCI support I think its safe to remove the make
> PCI optional part of the patch as this should be handled runtime not
> compile time.

I missed that part, must be something wrong work in Sunday :)
I will update the patch with ACPI depends on PCI, which makes
thing much simpler.

Thanks
Hanjun
