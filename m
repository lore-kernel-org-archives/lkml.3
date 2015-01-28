Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbbA1Uxi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:53:38 -0500
Received: from mail-qg0-f42.google.com ([209.85.192.42]:49246 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062AbbA1Uxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:53:33 -0500
MIME-Version: 1.0
In-Reply-To: <1422450981-9328-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1422450981-9328-1-git-send-email-srinivas.kandagatla@linaro.org>
Date: Wed, 28 Jan 2015 14:35:22 +0100
Message-ID: <CAPDyKFquQgut1ZC9Jj=rbNwRKs3Qwr5LsUy_cmY7g2L8MG657Q@mail.gmail.com>
Subject: Re: [PATCH 0/2] mmc: pwrseq: Add support to multiple gpios in pwrseq simple
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Rob Herring <robh+dt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 January 2015 at 14:16, Srinivas Kandagatla
<srinivas.kandagatla@linaro.org> wrote:
> This patchset adds support to reset/powerup multiple gpio pins on a given
> sdio bus. The use case is simple, on sdio we could have multiple devices
> like WLAN, BT which are controlled by there own reset lines. So having
> multiple reset is something more useful in such cases.
>
> Without this patch I could not get BT and WLAN working at same time on IFC6410.
>
> Thanks,
> srini
>
> Srinivas Kandagatla (2):
>   mmc: pwrseq: Add support to control multiple gpios in simple pwrseq
>   mmc: pwrseq: Update document with multiple gpios support
>
>  .../devicetree/bindings/mmc/mmc-pwrseq-simple.txt  |  7 ++-
>  drivers/mmc/core/pwrseq_simple.c                   | 64 +++++++++++++++-------
>  2 files changed, 49 insertions(+), 22 deletions(-)
>
> --
> 1.9.1
>

Hi Srinivas,

I noticed that Javier a few hours ago posted a patchset which
implement the same thing as yours, I guess this is a wanted feature.
:-)

I am going to review Javier's patchset, would be nice if you could
have a look at it as well.

Kind regards
Uffe
