Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbaEMPjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:39:12 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57939 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290AbaEMPjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:39:06 -0400
Message-ID: <53723C96.5020203@wwwdotorg.org>
Date: Tue, 13 May 2014 09:39:02 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alexandre Courbot <gnurou@gmail.com>
CC: Alexandre Courbot <acourbot@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: tegra: joystick input in tegra_defconfig
References: <1399883209-31169-1-git-send-email-acourbot@nvidia.com> <1399883209-31169-2-git-send-email-acourbot@nvidia.com> <5370F794.2020800@wwwdotorg.org> <CAAVeFuLZ_wrxipYn2pfNzuyDiTvAPWH4aSWfonrG+YQsm4tM_g@mail.gmail.com>
In-Reply-To: <CAAVeFuLZ_wrxipYn2pfNzuyDiTvAPWH4aSWfonrG+YQsm4tM_g@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2014 09:45 PM, Alexandre Courbot wrote:
> On Tue, May 13, 2014 at 1:32 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 05/12/2014 02:26 AM, Alexandre Courbot wrote:
>>> NVIDIA SHIELD embeds a USB controller. Compile the corresponding support
>>> as a module in tegra_defconfig.
>>
>> Why make this a module rather than built-in. Almost everything else in
>> tegra_defconfig is built-in, except brcmfmac since it doesn't handle
>> lack of firmware availability at probe time.
> 
> Goal is to minimize the image size, especially since this is not a
> feature I expect to be used much outside of SHIELD. If you prefer it
> built-in, I'm fine with it too.

Yes, built-in for everything makes most sense to me, except for code
that doesn't actually work unless it's a module.

