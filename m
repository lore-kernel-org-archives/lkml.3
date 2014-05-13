Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352AbaEMDqH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 23:46:07 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:59176 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbaEMDqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 23:46:04 -0400
MIME-Version: 1.0
In-Reply-To: <5370F794.2020800@wwwdotorg.org>
References: <1399883209-31169-1-git-send-email-acourbot@nvidia.com>
 <1399883209-31169-2-git-send-email-acourbot@nvidia.com> <5370F794.2020800@wwwdotorg.org>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 13 May 2014 12:45:43 +0900
Message-ID: <CAAVeFuLZ_wrxipYn2pfNzuyDiTvAPWH4aSWfonrG+YQsm4tM_g@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: tegra: joystick input in tegra_defconfig
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 1:32 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 05/12/2014 02:26 AM, Alexandre Courbot wrote:
>> NVIDIA SHIELD embeds a USB controller. Compile the corresponding support
>
> USB controller or USB joystick?

I understand this sounds like "EHCI controller" here. Will reword.

>
>> as a module in tegra_defconfig.
>
> Why make this a module rather than built-in. Almost everything else in
> tegra_defconfig is built-in, except brcmfmac since it doesn't handle
> lack of firmware availability at probe time.

Goal is to minimize the image size, especially since this is not a
feature I expect to be used much outside of SHIELD. If you prefer it
built-in, I'm fine with it too.

Thanks,
Alex.
