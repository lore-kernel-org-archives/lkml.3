Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbaFXPJJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:09:09 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:62250 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906AbaFXPJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:09:07 -0400
MIME-Version: 1.0
In-Reply-To: <1403614495-9291-1-git-send-email-k.debski@samsung.com>
References: <1403614495-9291-1-git-send-email-k.debski@samsung.com>
Date: Tue, 24 Jun 2014 16:09:04 +0100
Message-ID: <CAD8Lp441832-ZVV8FQChEXcLqVpZqygv3iaF95_SfZOH_xkFPg@mail.gmail.com>
Subject: Re: [PATCH] phy: phy-samsung-usb2: Change phy power on/power off sequence
From: Daniel Drake <drake@endlessm.com>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-usb@vger.kernel.org, kishon@ti.com,
        Tomasz Figa <t.figa@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>, gautam.vivek@samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 1:54 PM, Kamil Debski <k.debski@samsung.com> wrote:
> The Exynos4412 USB 2.0 PHY hardware differs from the description provided
> in the documentation. Some register bits have different function. This
> patch fixes the defines of register bits and changes the way how phys are
> powered on and off.

I guess this replaces the patch titled "drivers: phy: exynos4x12-phy:
fix HSIC1 power on/off sequence"

Tested on ODROID-U2. Seems to be working as well as the previous patch:
- Internal SMSC hub works on boot and after reboot, tested with USB mouse
- Internal SMSC ethernet device works on boot, but disappears upon
reboot. (same as previous patch, also reproduced by Marek)

Thanks,
Daniel
