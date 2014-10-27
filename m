Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbaJ0XZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 19:25:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34036 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685AbaJ0XZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 19:25:26 -0400
Message-ID: <544ED462.20601@suse.de>
Date: Tue, 28 Oct 2014 00:25:22 +0100
From: Alexander Graf <agraf@suse.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        =?UTF-8?B?QW5kcg==?= =?UTF-8?B?ZWFzIEbDpHJiZXI=?= 
	<afaerber@suse.de>
CC: "mark.rutland@arm.com" <mark.rutland@arm.com>,
        Thomas Lendacky <Thomas.Lendacky@amd.com>,
        Joel Schopp <Joel.Schopp@amd.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "liviu.dudau@arm.com" <liviu.dudau@arm.com>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm64: amd-seattle: Adding device tree for AMD Seattle
 platform
References: <1414153221-13104-1-git-send-email-suravee.suthikulpanit@amd.com> <544C2D67.8000405@suse.de> <544CEC5B.4020104@suse.de> <A1BC53C1-A78E-4B0C-879B-F6A462E58C72@suse.de> <544E56DB.7020305@amd.com>
In-Reply-To: <544E56DB.7020305@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 27.10.14 15:29, Suravee Suthikulanit wrote:
> On 10/26/2014 9:08 AM, Alexander Graf wrote:
>>>> This option doesn't exist in upstream kernels, does it? Why not just
>>>> >>make it dtb-y?
>>> >
>>> >CONFIG_ARCH_SEATTLE is being added one hunk above.:)
>> Oops:).
>>
>> I'm not convinced we need a config option just for the sake of
>> compiling a device tree though.
>>
>>
>> Alex
>>
> 
> Eventually, we would add other device driver selections when
> CONFIG_ARCH_SEATTLE=y. At this point, those drivers are still not ready.

Could you please give me some examples of drivers that would depend on
CONFIG_ARCH_SEATTLE? I like the current way things work without the need
for such an option, where everything's implemented purely as drivers you
can opt in our out of.

You don't have a CONFIG_ARCH_SB7XX on x86 either, right? ;)


Alex
