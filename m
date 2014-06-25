Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454AbaFYI4c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 04:56:32 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:37639 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbaFYI42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 04:56:28 -0400
MIME-Version: 1.0
In-Reply-To: <1403626107-12073-1-git-send-email-t.figa@samsung.com>
References: <1403626107-12073-1-git-send-email-t.figa@samsung.com>
Date: Wed, 25 Jun 2014 09:56:25 +0100
Message-ID: <CAD8Lp45r4yMq2Ew9Eijs-udLUyteZjriG_86XcQfELvdTbJVNA@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] Add support for Exynos clock output configuration
From: Daniel Drake <drake@endlessm.com>
To: Tomasz Figa <t.figa@samsung.com>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jun 24, 2014 at 5:08 PM, Tomasz Figa <t.figa@samsung.com> wrote:
> Tested on Odroid U3, with HSIC/USB hub using CLKOUT as reference clock,
> with some additional patches.

for all the patches:
Tested-by: Daniel Drake <drake@endlessm.com>

Tested on ODROID-U2 alongside
    phy: phy-samsung-usb2: Change phy power on/power off sequence

now USB is working fine.

Thanks!
Daniel
