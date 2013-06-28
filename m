Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab3F1OJf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 10:09:35 -0400
Received: from mail-vb0-f43.google.com ([209.85.212.43]:54955 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab3F1OJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 10:09:33 -0400
MIME-Version: 1.0
In-Reply-To: <1372427593.4257.7.camel@pizza.hi.pengutronix.de>
References: <1372390325-7566-1-git-send-email-festevam@gmail.com>
	<1372390325-7566-5-git-send-email-festevam@gmail.com>
	<1372427593.4257.7.camel@pizza.hi.pengutronix.de>
Date: Fri, 28 Jun 2013 11:09:33 -0300
Message-ID: <CAOMZO5As90NNdDoYSmCmXq5UB5j2YgdgTnjMbyqz7X0hT5e=uQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] imx-drm: ipu-dp: Adjust the maximum number of flows
From: Fabio Estevam <festevam@gmail.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: gregkh@linuxfoundation.org, shawn.guo@linaro.org, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

On Fri, Jun 28, 2013 at 10:53 AM, Philipp Zabel <p.zabel@pengutronix.de> wrote:

>
> If (flow == IPUV3_NUM_FLOWS << 1), this will continue and try to access
> &priv->flow[3] below, which is invalid. How about
>
> +       if ((flow >> 1) >= IPUV3_NUM_FLOWS)
>
> instead?

Yes, agreed.

Thanks,

Fabio Estevam
