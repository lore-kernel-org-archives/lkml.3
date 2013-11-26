Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab3KZBg0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 20:36:26 -0500
Received: from mail-vb0-f48.google.com ([209.85.212.48]:57515 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab3KZBgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 20:36:20 -0500
MIME-Version: 1.0
In-Reply-To: <20131126000608.GA21634@quad.lixom.net>
References: <1385274652-16415-1-git-send-email-acourbot@nvidia.com>
 <1385274652-16415-8-git-send-email-acourbot@nvidia.com> <20131126000608.GA21634@quad.lixom.net>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 26 Nov 2013 10:35:58 +0900
Message-ID: <CAAVeFu+mMyPhFtVZ09vgYWWCYkPpF3X547ffRAfXXKOOWUUkqg@mail.gmail.com>
Subject: Re: [PATCH v11 7/7] ARM: tegra: support Trusted Foundations by default
To: Olof Johansson <olof@lixom.net>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>,
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

On Tue, Nov 26, 2013 at 9:06 AM, Olof Johansson <olof@lixom.net> wrote:
> On Sun, Nov 24, 2013 at 03:30:52PM +0900, Alexandre Courbot wrote:
>> Support for Trusted Foundations is light and allows the kernel to run on
>> a wider range of devices, so enable it by default.
>>
>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
>> Reviewed-by: Stephen Warren <swarren@nvidia.com>
>> ---
>>  arch/arm/configs/tegra_defconfig | 1 +
>>  1 file changed, 1 insertion(+)
>
> I think we want this enabled on multi_v7_defconfig too? Send a separate
> patch for that once this is merged though.

Will do.

Thanks,
Alex.
