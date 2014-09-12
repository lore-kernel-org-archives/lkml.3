Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbaILVb0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 17:31:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12893 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbaILVbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 17:31:23 -0400
Message-ID: <541365D9.4050908@redhat.com>
Date: Fri, 12 Sep 2014 17:30:01 -0400
From: Jon Masters <jcm@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <Marc.Zyngier@arm.com>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        Mark Brown <broonie@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>
Subject: Re: [PATCH v3 09/17] ARM64 / ACPI: Parse MADT for SMP initialization
References: <1409583475-6978-1-git-send-email-hanjun.guo@linaro.org> <1409583475-6978-10-git-send-email-hanjun.guo@linaro.org> <540E80BD.20801@redhat.com> <540E88A2.1000606@linaro.org> <540E93A0.4040306@redhat.com> <540F2422.90105@linaro.org> <540F24FF.2060302@redhat.com> <20140911141508.GK6158@arm.com>
In-Reply-To: <20140911141508.GK6158@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2014 10:15 AM, Will Deacon wrote:
> On Tue, Sep 09, 2014 at 05:04:15PM +0100, Jon Masters wrote:
>> On 09/09/2014 12:00 PM, Hanjun Guo wrote:
>>> No, you didn't miss it, I'm still working on the new version, sorry I didn't
>>> clarify that in my previous email.
>>
>> Thanks. If you could copy me on the next posting that would rock. In a
>> few hours we should have another platform posted as an example. In
>> addition, a couple of lower priority patches (building upon the core
>> ACPI pieces) should be posted as well.
> 
> Can I breath out yet or did I miss the platform posting?

There's a posting for AMD Seattle coming soon as an example. Also, there
should be some hardware at Connect on which patches can run.

Jon.

