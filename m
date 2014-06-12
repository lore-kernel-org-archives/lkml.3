Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932915AbaFLIgc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 04:36:32 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:50558 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932399AbaFLIga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 04:36:30 -0400
MIME-Version: 1.0
In-Reply-To: <53996247.5020203@free.fr>
References: <53996247.5020203@free.fr>
Date: Thu, 12 Jun 2014 14:06:28 +0530
X-Google-Sender-Auth: dzPH7T-GkxXhAgSR8r-7FmzSag4
Message-ID: <CAK5sBcH-6xeKomVay4PFWzLV8M-Sx=jankcE-7mj7K00=Gwe4w@mail.gmail.com>
Subject: Re: [PATCH] phy: Fix typo in drivers/phy/phy-exynos5250-sata.c module
 which fixes the build
From: Sachin Kamat <sachin.kamat@samsung.com>
To: guillaume.gardet@free.fr
Cc: linux-kernel@vger.kernel.org,
        openSUSE Kernel ML <opensuse-kernel@opensuse.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Girish K S <ks.giri@samsung.com>, Yuvaraj C D <yuvaraj.cd@samsung.com>,
        Jean Delvare <jdelvare@suse.de>, Sachin Kamat <spk.linux@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guillaume,


On Thu, Jun 12, 2014 at 1:48 PM, Guillaume Gardet
<guillaume.gardet@free.fr> wrote:
> Hi,
>
> please find in attachment a patch which fixes a typo in drivers/phy/phy-exynos5250-sata.c module license.
> It fixes the following build error:
>     FATAL: modpost: GPL-incompatible module phy-exynos5250-sata.ko uses GPL-only symbol 'platform_driver_unregister'
>
> Please keep me in CC since I am not subscribed to the linux-kernel@vger.kernel.org ML.
>
> Signed-off-by: Guillaume GARDET <guillaume.gardet@opensuse.org>

A similar patch has already been submitted by Arnd. Please see below:
https://lkml.org/lkml/2014/3/15/40

In general, sending an attachment is not the right way to submit a patch.
Please refer Documentation/SubmittingPatches in the kernel source for the
correct procedure.

Regards,
Sachin.
