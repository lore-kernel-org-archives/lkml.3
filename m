Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbaBEPsb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 10:48:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbaBEPs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 10:48:29 -0500
Message-ID: <52F25D17.9080309@redhat.com>
Date: Wed, 05 Feb 2014 16:47:35 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?David_Lanzend=F6rfer?= <david.lanzendoerfer@o2s.ch>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
CC: devicetree@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Simon Baatz <gmbnomis@gmail.com>, linux-mmc@vger.kernel.org,
        Chris Ball <chris@printf.net>, linux-kernel@vger.kernel.org,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        linux-sunxi@googlegroups.com, Tejun Heo <tj@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/6] ARM: sunxi: Add driver for SD/MMC hosts found
 on allwinner sunxi SOCs
References: <20140204191648.29809.14611.stgit@dizzy-6.o2s.ch> <20140205103949.GC3192@lukather> <1676482.sbjAhaSLaV@dizzy-6.o2s.ch>
In-Reply-To: <1676482.sbjAhaSLaV@dizzy-6.o2s.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On 02/05/2014 02:01 PM, David Lanzendörfer wrote:
> Hi Maxime
>> I have four comments here:
>>    - Read Documentation/SubmittingPatches, especially Section 5 and 12
>>      (hints, you forgot the clock maintainers for your clock patches
>>      and you didn't put any signed-off-by tags)
> Oops. I added signed-offs now
>>    - You ignored pretty much all the comments that were made during the
>>      review of the first version. Go through
> Uh? I just fixed the commits and squashed them together for easier handling.
> I'm even using mmc_of_parse now...
>> http://lists.infradead.org/pipermail/linux-arm-kernel/2013-December/219339.
>> html and address the comments that were made.
>>    - Each of your patches should compile. Fix the order of your
>>      patches.
> Done.
>>    - Submit a v3, with the changes you made. Otherwise we have no way
>>      of knowing what have been fixed and what didn't
> Too many patches would be bloaty.
> That's why I've squashed them into small and corrected patches.

The squashing is fine, what Maxime means is that normally you would include
a changelog in the coverletter (the [patch 0/x] mail) documenting changes
done since the previous posting of the patchset, so for v3 that would have been
something like:

Changes since v1:
-use mmc_of_parse instead of diy dt parsing
-add nodes for all mmc controller to the dtsi files, including sofar unused
  controllers

Changes since v2:
-Add missing Signed-off-by tags
-stop using __raw_readl / __raw_writel so that barriers are properly used

I've probably forgotten a few things, it would be good if you could send
a reply to the:
"[PATCH v3 0/7] ARM: sunxi: Add driver for SD/MMC hosts found on allwinner sunxi SOCs"
mail with the above changelog, amended with whatever I've forgotten to add
to the above changelog

Thanks & Regards,

Hans

