Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237AbbAOVdb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 16:33:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932157AbbAOVd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 16:33:26 -0500
Message-ID: <54B831C9.3060700@redhat.com>
Date: Thu, 15 Jan 2015 14:31:53 -0700
From: Al Stone <ahs3@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>,
        Grant Likely <grant.likely@linaro.org>
CC: Will Deacon <Will.Deacon@arm.com>,
        "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh@kernel.org>, Robert Richter <rric@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
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
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org> <CACxGe6v_BvCQqp8d=LaQ8HeaOU1Zh_HPpwFTdwOjHUbqXsnQ8g@mail.gmail.com> <20150115182346.GE2329@e104818-lin.cambridge.arm.com>
In-Reply-To: <20150115182346.GE2329@e104818-lin.cambridge.arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2015 11:23 AM, Catalin Marinas wrote:
> On Thu, Jan 15, 2015 at 04:26:20PM +0000, Grant Likely wrote:
>> On Wed, Jan 14, 2015 at 3:04 PM, Hanjun Guo <hanjun.guo@linaro.org> wrote:
>>> This is the v7 of ACPI core patches for ARM64 based on ACPI 5.1
>>
>> I'll get right to the point: Can we please have this series queued up
>> for v3.20?
> [snip ... ]

>> 5. Platform support patches need verification and review
>>    * ACPI core works on at least the Foundation model, Juno, APM
>> Mustang, and AMD Seattle
>>    * There still are driver patches being discussed. See Al's summary
>> for details
>>    * As I argued above, the state of driver patches isn't going to be
> 
> We are still lacking here. To quote Al, "First version for AMD Seattle
> has been posted to the public linaro-acpi mailing list for initial
> review". Sorry but I don't follow linaro-acpi list. I don't know what's
> in those patches and I can't tell which subsystems they touch, whether
> maintainers agree with them. So in conclusion, I'm not confident the
> arm64 hardware ACPI story looks that great yet.
>  

This is solely my fault -- too much time on processes, email, and
documentation, not enough time on the Seattle patches.  And not
enough Seattles to go around for someone else to pick up the slack.

I am aware not everyone is subscribed to linaro-acpi; we use that
for internal review before posting more broadly, which is the only
reason I sent them there.

I'm in the middle of updating them as I have time, based on really
good feedback from Arnd; few of them are terribly new (the very first
posting was [0]) -- it's mostly a matter of rebasing, integrating
updates from AMD and others, and reacting to the comments.  One can
also see what these patches will probably look like via one of the
Fedora kernel trees [1].


[0] https://lkml.org/lkml/2014/9/15/1308
[1] https://git.fedorahosted.org/git/kernel-arm64 -- this is
    what I run on an AMD Seattle daily driver, btw, and is used
    in Fedora 21 as well.

-- 
ciao,
al
-----------------------------------
Al Stone
Software Engineer
Red Hat, Inc.
ahs3@redhat.com
-----------------------------------
