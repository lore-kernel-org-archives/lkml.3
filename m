Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab3LCAtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 19:49:45 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:54109 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab3LCAtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 19:49:20 -0500
MIME-Version: 1.0
In-Reply-To: <20131126001033.GB21634@quad.lixom.net>
References: <1385274652-16415-1-git-send-email-acourbot@nvidia.com> <20131126001033.GB21634@quad.lixom.net>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 3 Dec 2013 09:48:59 +0900
Message-ID: <CAAVeFuKh7T42AfAud=ZJ-j_7BgeRUFOytD7CNQ_DFdZeQRHj4A@mail.gmail.com>
Subject: Re: [PATCH v11 0/7] ARM: support for the Trusted Foundations secure monitor
To: Russell King <linux@arm.linux.org.uk>
Cc: Olof Johansson <olof@lixom.net>, Alexandre Courbot <acourbot@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Tomasz Figa <t.figa@samsung.com>, Dave Martin <Dave.Martin@arm.com>,
        Kevin Hilman <khilman@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 9:10 AM, Olof Johansson <olof@lixom.net> wrote:
> On Sun, Nov 24, 2013 at 03:30:45PM +0900, Alexandre Courbot wrote:
>> New rebase that should be ready-to-apply on the latest Tegra tree. The last
>> remaining blocker is Russell's approval for this series and it is my hope to
>> obtain it with this version.
>>
>> There has been quite some debate around this series, notably about the SMC
>> calling conventions and whether the firmware interface should be moved out of
>> arch/arm. I hope that all the questions have been answered and that we can move
>> forward with this series that enables NVIDIA-branded retail Tegra devices to run
>> mainline.
>>
>> Changes since v10:
>> - Rebased on top of more recent sources since some files have been renamed in
>>   mach-tegra.
>> - Gave a final proof-read and extensive testing.
>>
>> Alexandre Courbot (7):
>>   ARM: add basic support for Trusted Foundations
>>   of: add vendor prefix for Trusted Logic Mobility
>>   of: add Trusted Foundations bindings documentation
>>   ARM: tegra: add support for Trusted Foundations
>>   ARM: tegra: split setting of CPU reset handler
>>   ARM: tegra: set CPU reset handler using firmware
>>   ARM: tegra: support Trusted Foundations by default
>
> Ok, this looks good to me. Russell, do you want the first patch in your
> tree or are you ok with acking that and we can take everything through
> arm-soc?
>
> The alternative is that we can have Stephen provide a stable branch with
> the first patch on it and we both merge that, then the rest goes on top
> of that through arm-soc.

Russell, ping?
