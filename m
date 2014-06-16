Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468AbaFPSa0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 14:30:26 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:48108 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170AbaFPSaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 14:30:25 -0400
MIME-Version: 1.0
In-Reply-To: <539F33FE.8040501@wwwdotorg.org>
References: <1401920421-25729-1-git-send-email-dianders@chromium.org>
	<539F33FE.8040501@wwwdotorg.org>
Date: Mon, 16 Jun 2014 11:30:23 -0700
X-Google-Sender-Auth: 3GysYCUCGJ0NxWglVsLdw1cl2zU
Message-ID: <CAD=FV=W=qvzM6i3GhOsHO_2tPEZOVjq+TEKUrfdCVk_4eRo-Pw@mail.gmail.com>
Subject: Re: [PATCH 1/3] ARM: dts: Create a cros-ec-keyboard fragment
From: Doug Anderson <dianders@chromium.org>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Stephen Warren <swarren@nvidia.com>, Thierry Reding <treding@nvidia.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Olof Johansson <olof@lixom.net>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kukjin,

On Mon, Jun 16, 2014 at 11:14 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 06/04/2014 04:20 PM, Doug Anderson wrote:
>> All ChromeOS ARM devices that have the standard "CrOS EC" have the
>> same keyboard mapping.  It's silly to include this same definition
>> everywhere.  Let's create a "dtsi" fragment that we can include from
>> many different boards.
>>
>> This fragment is based on what's currently in tegra124-venice2.dts
>
> I've applied this series to Tegra's for-3.17/dt-cros-ec-kbd branch. I'll
> send a pull request to arm-soc shortly.

It seems like you might want to merge from Stephen's branch
<https://git.kernel.org/cgit/linux/kernel/git/tegra/linux.git/log/?h=for-3.17/dt-cros-ec-kbd>
into your tree to avoid any future conflicts to exynos5250-snow (and
also to allow you to apply
https://patchwork.kernel.org/patch/4351321/).

-Doug
