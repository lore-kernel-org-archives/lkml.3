Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933556Ab3JOSOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 14:14:45 -0400
Received: from mail-qe0-f42.google.com ([209.85.128.42]:55692 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932555Ab3JOSOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 14:14:43 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <1381850098-12357-1-git-send-email-pdeschrijver@nvidia.com>
References: <1381850098-12357-1-git-send-email-pdeschrijver@nvidia.com>
Date: Tue, 15 Oct 2013 11:14:42 -0700
Message-ID: <CAOesGMiXDqO9tKaj1s_hN32q_bPdLVojWPe2LweURDq-b2784w@mail.gmail.com>
Subject: Re: [PATCH v2 0/7] Tegra124 clock support
From: Olof Johansson <olof@lixom.net>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[devicetree to bcc]

Peter,

Please don't post driver/platform patches to the devicetree list. Only
bindings updates should be posted here.

Otherwise the volume of patches make the people who need to see the
and review the bindings run for the hills. :-)


-Olof

On Tue, Oct 15, 2013 at 8:14 AM, Peter De Schrijver
<pdeschrijver@nvidia.com> wrote:
> This series introduces support for the Tegra124 CAR clocks.
> Based on '[PATCH v3 00/12] Introduce common infra for tegra clocks'
>
> changes since v1:
>
> + suspend/resume for LP1 (Joseph Lo)
> + fixed some comments
> + account for changes to the common infra code
>
> Joseph Lo (2):
>   clk: tegra124: add wait_for_reset and disable_clock for
>     tegra_cpu_car_ops
>   clk: tegra124: add suspend/resume function for tegra_cpu_car_ops
>
> Peter De Schrijver (5):
>   clk: tegra: Add support for PLLSS
>   clk: tegra: Add periph regs bank X
>   clk: tegra124: Add common clk IDs to clk-id.h
>   clk: tegra124: Add new peripheral clocks
>   clk: tegra124: Add support for Tegra124 clocks
>
>  drivers/clk/tegra/Makefile               |    1 +
>  drivers/clk/tegra/clk-id.h               |   20 +
>  drivers/clk/tegra/clk-pll.c              |  172 ++++
>  drivers/clk/tegra/clk-tegra-periph.c     |   55 ++
>  drivers/clk/tegra/clk-tegra124.c         | 1430 ++++++++++++++++++++++++++++++
>  drivers/clk/tegra/clk.c                  |   10 +
>  drivers/clk/tegra/clk.h                  |    5 +
>  include/dt-bindings/clock/tegra124-car.h |  341 +++++++
>  8 files changed, 2034 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/clk/tegra/clk-tegra124.c
>  create mode 100644 include/dt-bindings/clock/tegra124-car.h
>
> --
> 1.7.7.rc0.72.g4b5ea.dirty
>
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
