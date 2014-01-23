Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147AbaAWHij (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 02:38:39 -0500
Received: from mail-ve0-f176.google.com ([209.85.128.176]:36218 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbaAWHig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 02:38:36 -0500
MIME-Version: 1.0
In-Reply-To: <52E02D40.3090803@wwwdotorg.org>
References: <1390299016-14105-1-git-send-email-acourbot@nvidia.com>
 <1390299016-14105-4-git-send-email-acourbot@nvidia.com> <52E02D40.3090803@wwwdotorg.org>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 23 Jan 2014 16:38:15 +0900
Message-ID: <CAAVeFu+Eca6WGEL02nYskNQfB9=36_faZyGnQeSRrQEiXZx25A@mail.gmail.com>
Subject: Re: [PATCH 3/5] ARM: firmware: enable Trusted Foundations by default
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 5:42 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 01/21/2014 03:10 AM, Alexandre Courbot wrote:
>> As discussed previously (https://lkml.org/lkml/2013/11/26/289), enable
>> Trusted Foundation support by default since it already depends on a
>> supporting architecture being selected.
>>
>> Doing so allows us to remove it from tegra_defconfig.
>
>>  arch/arm/configs/tegra_defconfig | 1 -
>>  arch/arm/firmware/Kconfig        | 1 +
>
> Can we split out the defconfig and code changes into separate patches?
> They need to go through seperate branches, possibly even separate repos.
>
> The defconfig change might not even be necessary; at some point I'll
> just rebuild it via "make tegra_defconfig; make savedefconfig" on top of
> some linux-next that includes the Kconfig change, and it'll happen
> automatically. Still, I guess there's no harm explicitly sending the patch.

If we can do without the defconfig change then I will just omit it in
the next version - I don't like sending too many oneliners. :P
