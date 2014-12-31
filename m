Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570AbaLaPI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 10:08:27 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:55906 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaLaPIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 10:08:25 -0500
Message-ID: <d3ea3f18e4d9ca9c623e3632129caee6.squirrel@www.codeaurora.org>
In-Reply-To: <54A3B526.9040903@linaro.org>
References: <1413553034-20956-1-git-send-email-hanjun.guo@linaro.org>
    <1413553034-20956-19-git-send-email-hanjun.guo@linaro.org>
    <CAJ5Y-eZ5cu9_OhG24yAv+CZq7zKg0vU+eVGekyN+9dDzaz1OhQ@mail.gmail.com>
    <8fc9550c96a468b3e50d51a37db68a33.squirrel@www.codeaurora.org>
    <54A3B526.9040903@linaro.org>
Date: Wed, 31 Dec 2014 15:08:23 -0000
Subject: Re: [PATCH v5 18/18] Documentation: ACPI for ARM64
From: ashwinc@codeaurora.org
To: "Hanjun Guo" <hanjun.guo@linaro.org>
Cc: ashwinc@codeaurora.org, catalin.marinas@arm.com, rjw@rjwysocki.net,
        mark.rutland@arm.com, olof@lixom.net, grant.likely@linaro.org,
        will.deacon@arm.com, linaro-acpi@lists.linaro.org, liviu.dudau@arm.com,
        lv.zheng@intel.com, robh@kernel.org, lorenzo.pieralisi@arm.com,
        al.stone@linaro.org, daniel.lezcano@linaro.org, robert.moore@intel.com,
        linux-acpi@vger.kernel.org, charles.garcia-tobin@arm.com,
        rric@kernel.org, jason@lakedaemon.net, arnd@arndb.de,
        marc.zyngier@arm.com, jcm@redhat.com, broonie@kernel.org,
        "bhelgaas@google.com." <linux-arm-kernel@lists.infradead.org>,
        graeme.gregory@linaro.org, kangkang.shen@huawei.com,
        rdunlap@infradead.org, linux-kernel@vger.kernel.org,
        sudeep.holla@arm.com
User-Agent: SquirrelMail/1.4.22-4.el6
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 December 2014 at 03:34, Hanjun Guo <hanjun.guo@linaro.org> wrote:
> On 2014年12月31日 04:13, ashwinc@codeaurora.org wrote:
>> Hi Hanjun,
>>> +ASWG
>>> +----
>>> +The following areas are not yet fully defined for ARM in the 5.1
>>> version
>>> +of the ACPI specification and are expected to be worked through in the
>>> +UEFI ACPI Specification Working Group (ASWG):
>>> +
>>> +   -- ACPI based CPU topology
>>> +   -- ACPI based Power management
>>
>> Should clarify this to idle management rather than generic power
>> management.
>
> and I think it is CPU idle specific here, right?
>

Right.

Thanks,
Ashwin

--
Qualcomm Innovation Center, Inc
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

--

