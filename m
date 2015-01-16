Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492AbbAPPZK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 10:25:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904AbbAPPZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 10:25:09 -0500
Message-ID: <54B92CFA.2040101@redhat.com>
Date: Fri, 16 Jan 2015 08:23:38 -0700
From: Al Stone <ahs3@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Al Stone <al.stone@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>
CC: linaro-acpi <linaro-acpi@lists.linaro.org>,
        Will Deacon <Will.Deacon@arm.com>, Yijing Wang <wangyijing@huawei.com>,
        Rob Herring <robh@kernel.org>, Timur Tabi <timur@codeaurora.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        "phoenix.liyi@huawei.com" <phoenix.liyi@huawei.com>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <Marc.Zyngier@arm.com>,
        "jcm@redhat.com" <jcm@redhat.com>, Mark Brown <broonie@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [Linaro-acpi] [PATCH v7 00/17] Introduce ACPI for ARM64 based
 on ACPI 5.1
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org> <CACxGe6v_BvCQqp8d=LaQ8HeaOU1Zh_HPpwFTdwOjHUbqXsnQ8g@mail.gmail.com> <20150115182346.GE2329@e104818-lin.cambridge.arm.com> <54B831C9.3060700@redhat.com> <20150116102035.GD13634@e104818-lin.cambridge.arm.com> <54B92B99.5000604@linaro.org>
In-Reply-To: <54B92B99.5000604@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2015 08:17 AM, Al Stone wrote:
> On 01/16/2015 03:20 AM, Catalin Marinas wrote:
>> On Thu, Jan 15, 2015 at 09:31:53PM +0000, Al Stone wrote:
>>> On 01/15/2015 11:23 AM, Catalin Marinas wrote:
>>>> On Thu, Jan 15, 2015 at 04:26:20PM +0000, Grant Likely wrote:
>>>>> On Wed, Jan 14, 2015 at 3:04 PM, Hanjun Guo <hanjun.guo@linaro.org> wrote:
>>>>>> This is the v7 of ACPI core patches for ARM64 based on ACPI 5.1
>>>>>
>>>>> I'll get right to the point: Can we please have this series queued up
>>>>> for v3.20?
>>>> [snip ... ]
>>>
>>>>> 5. Platform support patches need verification and review
>>>>>    * ACPI core works on at least the Foundation model, Juno, APM
>>>>> Mustang, and AMD Seattle
>>>>>    * There still are driver patches being discussed. See Al's summary
>>>>> for details
>>>>>    * As I argued above, the state of driver patches isn't going to be
>>>>
>>>> We are still lacking here. To quote Al, "First version for AMD Seattle
>>>> has been posted to the public linaro-acpi mailing list for initial
>>>> review". Sorry but I don't follow linaro-acpi list. I don't know what's
>>>> in those patches and I can't tell which subsystems they touch, whether
>>>> maintainers agree with them. So in conclusion, I'm not confident the
>>>> arm64 hardware ACPI story looks that great yet.
>>>>  
>>>
>>> This is solely my fault -- too much time on processes, email, and
>>> documentation, not enough time on the Seattle patches.  And not
>>> enough Seattles to go around for someone else to pick up the slack.
>>>
>>> I am aware not everyone is subscribed to linaro-acpi; we use that
>>> for internal review before posting more broadly, which is the only
>>> reason I sent them there.
>>>
>>> I'm in the middle of updating them as I have time, based on really
>>> good feedback from Arnd; few of them are terribly new (the very first
>>> posting was [0]) -- it's mostly a matter of rebasing, integrating
>>> updates from AMD and others, and reacting to the comments.  One can
>>> also see what these patches will probably look like via one of the
>>> Fedora kernel trees [1].
>>
>> Do you have some simple branch against mainline with just the ACPI core
>> patches and what's required for AMD Seattle? I have no plans to dig
>> through the Fedora kernels.
>>
> 
> Nor was I expecting you to; I only added it as additional reference
> material, should one be interested.
> 
> The version of patches sent to the linaro-acpi list are from the Linaro
> acpi.git tree, and are precisely what you describe; those are the ones
> being updated.
> 

My bad, not enough coffee yet.  The Linaro acpi.git tree is at:

   https://git.linaro.org/leg/acpi/acpi.git

-- 
ciao,
al
-----------------------------------
Al Stone
Software Engineer
Red Hat, Inc.
ahs3@redhat.com
-----------------------------------
