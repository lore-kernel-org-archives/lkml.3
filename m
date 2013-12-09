Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab3LIRVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 12:21:39 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:52845 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab3LIRVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 12:21:36 -0500
Message-ID: <52A5FC1C.70400@wwwdotorg.org>
Date: Mon, 09 Dec 2013 10:21:32 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Alexandre Courbot <gnurou@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
CC: Olof Johansson <olof@lixom.net>, Alexandre Courbot <acourbot@nvidia.com>,
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
Subject: Re: [PATCH v11 0/7] ARM: support for the Trusted Foundations secure
 monitor
References: <1385274652-16415-1-git-send-email-acourbot@nvidia.com> <20131126001033.GB21634@quad.lixom.net> <CAAVeFuKh7T42AfAud=ZJ-j_7BgeRUFOytD7CNQ_DFdZeQRHj4A@mail.gmail.com>
In-Reply-To: <CAAVeFuKh7T42AfAud=ZJ-j_7BgeRUFOytD7CNQ_DFdZeQRHj4A@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2013 05:48 PM, Alexandre Courbot wrote:
> On Tue, Nov 26, 2013 at 9:10 AM, Olof Johansson <olof@lixom.net> wrote:
>> On Sun, Nov 24, 2013 at 03:30:45PM +0900, Alexandre Courbot wrote:
>>> New rebase that should be ready-to-apply on the latest Tegra tree. The last
>>> remaining blocker is Russell's approval for this series and it is my hope to
>>> obtain it with this version.
>>>
>>> There has been quite some debate around this series, notably about the SMC
>>> calling conventions and whether the firmware interface should be moved out of
>>> arch/arm. I hope that all the questions have been answered and that we can move
>>> forward with this series that enables NVIDIA-branded retail Tegra devices to run
>>> mainline.
>>>
>>> Changes since v10:
>>> - Rebased on top of more recent sources since some files have been renamed in
>>>   mach-tegra.
>>> - Gave a final proof-read and extensive testing.
>>>
>>> Alexandre Courbot (7):
>>>   ARM: add basic support for Trusted Foundations
>>>   of: add vendor prefix for Trusted Logic Mobility
>>>   of: add Trusted Foundations bindings documentation
>>>   ARM: tegra: add support for Trusted Foundations
>>>   ARM: tegra: split setting of CPU reset handler
>>>   ARM: tegra: set CPU reset handler using firmware
>>>   ARM: tegra: support Trusted Foundations by default
>>
>> Ok, this looks good to me. Russell, do you want the first patch in your
>> tree or are you ok with acking that and we can take everything through
>> arm-soc?
>>
>> The alternative is that we can have Stephen provide a stable branch with
>> the first patch on it and we both merge that, then the rest goes on top
>> of that through arm-soc.
> 
> Russell, ping?

Russell, are you OK with this series? If you could ack patch 1, that
would be great.

If I don't hear otherwise by Friday, I think the best thing is to merge
the whole series through the Tegra tree, although I'll structure it so
that patch 1 can be merged into other branches separately if needed.
