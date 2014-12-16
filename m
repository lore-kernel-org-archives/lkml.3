Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751231AbaLPBMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 20:12:55 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:39108 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbaLPBMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 20:12:53 -0500
MIME-Version: 1.0
In-Reply-To: <1418689340-29517-2-git-send-email-dianders@chromium.org>
References: <1418689340-29517-1-git-send-email-dianders@chromium.org>
	<1418689340-29517-2-git-send-email-dianders@chromium.org>
Date: Mon, 15 Dec 2014 17:12:52 -0800
X-Google-Sender-Auth: 05xqULdidgn2E-27eqwYYrKPWIg
Message-ID: <CAL1qeaHaNibn9pVdy4+2uWa+EC5FnoF5cuz9HdXD6CmiiBribg@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] mmc: dw_mmc: Use mmc_regulator_set_vqmmc in start_signal_voltage_switch
From: Andrew Bresticker <abrestic@chromium.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Heiko Stuebner <heiko@sntech.de>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>, Mark Brown <broonie@kernel.org>,
        Alexandru Stan <amstan@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Chris Ball <chris@printf.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug,

On Mon, Dec 15, 2014 at 4:22 PM, Doug Anderson <dianders@chromium.org> wrote:
> We've introduced a new helper in the MMC core:
> mmc_regulator_set_vqmmc().  Let's use this in dw_mmc.  Using this new
> helper has some advantages:
>
> 1. We get the mmc_regulator_set_vqmmc() behavior of trying to match
>    VQMMC and VMMC when the signal voltage is 3.3V.  This ensures max
>    compatibility.
>
> 2. We get rid of a few more warnings when probing unsupported
>    voltages.
>
> 3. We get rid of some non-dw_mmc specific code in dw_mmc.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Reviewed-by: Andrew Bresticker <abrestic@chromium.org>
