Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbaHGBfr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 21:35:47 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:58310 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283AbaHGBfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 21:35:45 -0400
MIME-Version: 1.0
In-Reply-To: <1407373713-26281-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1407373713-26281-1-git-send-email-javier.martinez@collabora.co.uk>
Date: Wed, 6 Aug 2014 22:35:42 -0300
Message-ID: <CAOMZO5CsUKuAcDMzHhy32457ihGqEBTdUijDbwA7QwUqq-ukbQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] ARM: dts: Add Peach Pit and Pi dts entry for atmel touchpad
From: Fabio Estevam <festevam@gmail.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, Stephen Warren <swarren@nvidia.com>,
        Yufeng Shen <miletus@chromium.org>, Benson Leung <bleung@chromium.org>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        linux-input@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 6, 2014 at 10:08 PM, Javier Martinez Canillas
<javier.martinez@collabora.co.uk> wrote:

> +&hsi2c_8 {
> +       status = "okay";
> +       clock-frequency = <333000>;

Doesn't it work at the more standard 400kHz i2c frequency?
