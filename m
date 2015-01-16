Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbbAPHY1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 02:24:27 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:38328 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbbAPHYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 02:24:25 -0500
Message-ID: <54B8BC9F.3020106@linaro.org>
Date: Fri, 16 Jan 2015 15:24:15 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, Jason Cooper <jason@lakedaemon.net>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "phoenix.liyi@huawei.com" <phoenix.liyi@huawei.com>,
        Timur Tabi <timur@codeaurora.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Yijing Wang <wangyijing@huawei.com>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linaro-acpi <linaro-acpi@lists.linaro.org>
Subject: Re: [PATCH v7 00/17] Introduce ACPI for ARM64 based on ACPI 5.1
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org> <CACxGe6v_BvCQqp8d=LaQ8HeaOU1Zh_HPpwFTdwOjHUbqXsnQ8g@mail.gmail.com> <20150115182346.GE2329@e104818-lin.cambridge.arm.com> <20150115190220.GF3043@sirena.org.uk> <20150115200437.GF24989@titan.lakedaemon.net> <20150115203159.GG3043@sirena.org.uk>
In-Reply-To: <20150115203159.GG3043@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015年01月16日 04:31, Mark Brown wrote:
> On Thu, Jan 15, 2015 at 03:04:37PM -0500, Jason Cooper wrote:
>> On Thu, Jan 15, 2015 at 07:02:20PM +0000, Mark Brown wrote:
>
>>> There's probably a bit of a process problem here - these patches are all
>>> being posted as part of big and apparently controversial threads with
>>> subject lines in the form "ARM / ACPI:" so people could be forgiven for
>>> just not even reading the e-mails enough to notice changes to their
>>> subsystems.  Is it worth posting those patches separately more directly
>>> to the relevant maintainers?
>
>> I think it's beneficial to post the entire series as one thread, but to
>> change the subject line of each patch to adequately reflect the affected
>> subsystem.
>
> Just changing the subject lines to be more suitable would help, but

OK, I will repost this patch set as you and Jason suggested soon.

Thanks
Hanjun
