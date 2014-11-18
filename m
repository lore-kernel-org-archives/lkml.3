Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319AbaKRR2E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 12:28:04 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:65110 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079AbaKRR2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 12:28:02 -0500
MIME-Version: 1.0
In-Reply-To: <1415904621-26800-1-git-send-email-abrestic@chromium.org>
References: <1415904621-26800-1-git-send-email-abrestic@chromium.org>
Date: Tue, 18 Nov 2014 09:28:00 -0800
X-Google-Sender-Auth: NTm13cuPVUBOCvJTn_JAGRMuPRs
Message-ID: <CAD=FV=WZx6r5L76Bfn2L8WeSU4hKwNJ=tZq_FoT3ot1Hd2ToeQ@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: Add support for IMG Pistachio
From: Doug Anderson <dianders@chromium.org>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        James Hartley <James.Hartley@imgtec.com>,
        Ezequiel Garcia <Ezequiel.Garcia@imgtec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

On Thu, Nov 13, 2014 at 10:50 AM, Andrew Bresticker
<abrestic@chromium.org> wrote:
> Add support for the DW MMC host found on the Imagination Pistachio SoC.
> Like the DW MMC hosts found on SOCFPGA and Rockchip SoCs, the DW MMC
> host on Pistachio requires the use of SDMMC_CMD_USE_HOLD_REG.
>
> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
> ---
>  .../devicetree/bindings/mmc/img-dw-mshc.txt        | 29 ++++++++++++++++++++++
>  drivers/mmc/host/dw_mmc-pltfm.c                    |  6 +++++
>  2 files changed, 35 insertions(+)

This seems quite sane to me.

Reviewed-by: Doug Anderson <dianders@chromium.org>
