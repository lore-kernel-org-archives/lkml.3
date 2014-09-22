Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbaIVW5H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 18:57:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37728 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754754AbaIVW5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 18:57:04 -0400
Message-ID: <5420A8F4.20909@redhat.com>
Date: Mon, 22 Sep 2014 16:55:48 -0600
From: Al Stone <ahs3@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Matthew Garrett <mjg59@srcf.ucam.org>
CC: Pavel Machek <pavel@ucw.cz>, Hanjun Guo <hanjun.guo@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>, linaro-acpi@lists.linaro.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>, linux-acpi@vger.kernel.org,
        Jon Masters <jcm@redhat.com>, Grant Likely <grant.likely@linaro.org>,
        Charles.Garcia-Tobin@arm.com, Robert Richter <rric@kernel.org>,
        Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>,
        Marc Zyngier <marc.zyngier@arm.com>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Mark Brown <broonie@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        Sudeep Holla <Sudeep.Holla@arm.com>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v4 18/18] Documentation: ACPI for ARM64
References: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org> <20140922194841.GA9868@amd> <20140922203136.GA32156@srcf.ucam.org> <2486199.jzqMgLksH8@vostro.rjw.lan>
In-Reply-To: <2486199.jzqMgLksH8@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2014 04:46 PM, Rafael J. Wysocki wrote:
> On Monday, September 22, 2014 09:31:36 PM Matthew Garrett wrote:
>> On Mon, Sep 22, 2014 at 09:48:41PM +0200, Pavel Machek wrote:
>>> On Fri 2014-09-12 22:00:16, Hanjun Guo wrote:
>>>> +No code shall be accepted into the kernel unless it complies with the released
>>>> +standards from UEFI ASWG. If there are features missing from ACPI to make it
>>>> +function on a platform, ECRs should be submitted to ASWG and go through the
>>>> +approval process.
>>>
>>> Surely this should be narrowed down somehow? Or is reading all the
>>> released standards from ASWG mandatory before patching the kernel now?
>>>
>>> Spelling out wtf ECR is would be nice, too.
>>
>> Explicit Change Request.

Actually, it's "Engineering Change Request" -- a standard document
format used by several of the UEFI working groups, including the ASWG.

 These can only be filed by paid-up members of
>> the UEFI Forum, so I suspect this requirement is going to be unworkable 
>> (there's plenty of ACPI support code for large x86 vendors which isn't 
>> part of any ACPI spec).
> 
> Why do you think so?
> 
> Linux Foundation can do that on behalf of the community if no one else.
> 

Exactly so.  Or, collaborate with the hardware vendor, or a distro
or anyone else that is a Promoter or Contributor as defined by UEFI
[0].  The only thing to keep clear when doing so is who owns the
intellectual property for any proposed change; this is one of the
reasons the UEFI Forum has paid membership levels -- to pay for the
legal assistance to make sure that the specs can be freely used.  As
someone who is part of the ASWG, I'd personally be glad to help out
however I can in this regard.

I'm also curious as to what's being referred to as ACPI support
code for large x86 vendors which is not part of the spec; I *think*
I know what's being described but a specific example would really
help me understand better.

Thanks.



[0] http://www.uefi.org/join

-- 
ciao,
al
-----------------------------------
Al Stone
Software Engineer
Red Hat, Inc.
ahs3@redhat.com
-----------------------------------
