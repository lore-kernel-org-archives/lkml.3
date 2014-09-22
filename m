Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbaIVWl0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 18:41:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42698 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754765AbaIVWlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 18:41:24 -0400
Message-ID: <5420A54B.8080202@redhat.com>
Date: Mon, 22 Sep 2014 16:40:11 -0600
From: Al Stone <ahs3@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>, Hanjun Guo <hanjun.guo@linaro.org>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sudeep Holla <Sudeep.Holla@arm.com>,
        Jon Masters <jcm@redhat.com>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org
Subject: Re: [PATCH v4 18/18] Documentation: ACPI for ARM64
References: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org> <1410530416-30200-19-git-send-email-hanjun.guo@linaro.org> <20140922194841.GA9868@amd>
In-Reply-To: <20140922194841.GA9868@amd>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2014 01:48 PM, Pavel Machek wrote:
> On Fri 2014-09-12 22:00:16, Hanjun Guo wrote:
>> From: Graeme Gregory <graeme.gregory@linaro.org>
>>
>> Add documentation for the guidelines of how to use ACPI
>> on ARM64.
> 
>> +No code shall be accepted into the kernel unless it complies with the released
>> +standards from UEFI ASWG. If there are features missing from ACPI to make it
>> +function on a platform, ECRs should be submitted to ASWG and go through the
>> +approval process.
> 
> Surely this should be narrowed down somehow? Or is reading all the
> released standards from ASWG mandatory before patching the kernel now?

Asking someone to read the ACPI standard when implementing ACPI
functionality is no different than doing the same thing for PCI,
SCSI, TCP/IP or any of a bazillion others that are used by the
kernel.  Yes, the wording of this sentence is awkward; that's a
very different problem and easily fixed.

> Spelling out wtf ECR is would be nice, too.

ECR stands for "Engineering Change Request".  It is simply a
recommended document format for requesting changes to be made to
the ACPI specification (and is also used by other UEFI working
groups).  The text can easily be fixed to make that clear.

> And if you expect all kernel contributors to comply with your
> favourite standards, you should put an URL where the standards can be
> downloaded here.
> 

Easily enough corrected; until the patch is updated, one can find
the specs at the oh so very cleverly named URL:

    http://www.uefi.org/specifications


-- 
ciao,
al
-----------------------------------
Al Stone
Software Engineer
Red Hat, Inc.
ahs3@redhat.com
-----------------------------------
