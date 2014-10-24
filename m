Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbaJXJEY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 05:04:24 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:59473 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832AbaJXJET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 05:04:19 -0400
MIME-Version: 1.0
In-Reply-To: <20141024080240.GN32045@tbergstrom-lnx.Nvidia.com>
References: <1413991587-11110-1-git-send-email-romain.perier@gmail.com>
	<20141023081230.GK32045@tbergstrom-lnx.Nvidia.com>
	<CABgxDoKm5kKKCTD1njAerUrM24iVcGRDuhJ7b4qBVPqKBC4ftQ@mail.gmail.com>
	<20141024080240.GN32045@tbergstrom-lnx.Nvidia.com>
Date: Fri, 24 Oct 2014 11:04:18 +0200
Message-ID: <CABgxDoLT7puSr11Xw3D7diGRXj15oktfd7=ATTvjmf2MKKYp0A@mail.gmail.com>
Subject: Re: [PATCH v1 1/5] mfd: tps65910: Convert ti,system-power-controller
 DT property to poweroff-source
From: Romain Perier <romain.perier@gmail.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, robh+dt@kernel.org,
        "pawel.moll" <pawel.moll@arm.com>, mark.rutland@arm.com,
        "ijc+devicetree" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Okay, will do these changes.

2014-10-24 10:02 GMT+02:00 Peter De Schrijver <pdeschrijver@nvidia.com>:
> On Thu, Oct 23, 2014 at 11:39:34AM +0200, PERIER Romain wrote:
>> Hi Peter,
>>
>> 2014-10-23 10:12 GMT+02:00 Peter De Schrijver <pdeschrijver@nvidia.com>:
>> > This breaks DT ABI stability right? An existing device tree using ti,system-power-controller won't work anymore after this patch right? I don't think that's acceptable.
>> >
>>
>> This is why I converted all dts which use "ti,system-power-controller"
>> and tps65910/tps65911 to the new property (everything is in the
>> patches serie). However, with an existing dtb it will no longer work,
>> yes.
>> What do you suggest ? keep these two properties in the driver ? :/
>>
>
> Yes. Existing DTs should work with new kernels. So there's no other choice
> than leaving support for the existing property in place. Obviously DTs for new
> boards can use the new standardized property.
>
> Cheers,
>
> Peter.
