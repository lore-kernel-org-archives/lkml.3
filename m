Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab3EZVCS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 17:02:18 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:53151 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170Ab3EZVCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 17:02:17 -0400
MIME-Version: 1.0
In-Reply-To: <1367863561-11534-6-git-send-email-fabio.estevam@freescale.com>
References: <1367863561-11534-1-git-send-email-fabio.estevam@freescale.com>
	<1367863561-11534-6-git-send-email-fabio.estevam@freescale.com>
Date: Sun, 26 May 2013 18:02:16 -0300
Message-ID: <CAOMZO5AACbyUbhhoMVM9zf=tTWsFJ0HcmFCfMW048JWKprEJjA@mail.gmail.com>
Subject: Re: [PATCH 06/13] pwm: pwm-mxs: Let device core handle pinctrl
From: Fabio Estevam <festevam@gmail.com>
To: Thierry Reding <thierry.reding@avionic-design.de>,
        Fabio Estevam <fabio.estevam@freescale.com>
Cc: shawn.guo@linaro.org, kernel@pengutronix.de, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

On Mon, May 6, 2013 at 3:05 PM, Fabio Estevam
<fabio.estevam@freescale.com> wrote:
> Since commit ab78029 (drivers/pinctrl: grab default handles from device core),
> we can rely on device core for handling pinctrl.
>
> So remove devm_pinctrl_get_select_default() from the driver.
>
> Cc: Thierry Reding <thierry.reding@avionic-design.de>
> Cc: <linux-kernel@vger.kernel.org>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Any comments on this one?
