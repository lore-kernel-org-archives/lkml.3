Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879AbaHGCSF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 22:18:05 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:47507 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550AbaHGCSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 22:18:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAOMZO5CsUKuAcDMzHhy32457ihGqEBTdUijDbwA7QwUqq-ukbQ@mail.gmail.com>
References: <1407373713-26281-1-git-send-email-javier.martinez@collabora.co.uk>
	<CAOMZO5CsUKuAcDMzHhy32457ihGqEBTdUijDbwA7QwUqq-ukbQ@mail.gmail.com>
Date: Wed, 6 Aug 2014 19:18:02 -0700
X-Google-Sender-Auth: Z0D2HybLEznMX0ki5D5-GaVt2dQ
Message-ID: <CAD=FV=VinL5msfGUrxT06vDiRW2ZCGU4cJpgQ5rhxTdrZihxYw@mail.gmail.com>
Subject: Re: [PATCH 1/1] ARM: dts: Add Peach Pit and Pi dts entry for atmel touchpad
From: Doug Anderson <dianders@chromium.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, Stephen Warren <swarren@nvidia.com>,
        Yufeng Shen <miletus@chromium.org>, Benson Leung <bleung@chromium.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fabio,

On Wed, Aug 6, 2014 at 6:35 PM, Fabio Estevam <festevam@gmail.com> wrote:
> On Wed, Aug 6, 2014 at 10:08 PM, Javier Martinez Canillas
> <javier.martinez@collabora.co.uk> wrote:
>
>> +&hsi2c_8 {
>> +       status = "okay";
>> +       clock-frequency = <333000>;
>
> Doesn't it work at the more standard 400kHz i2c frequency?

I'm pretty sure that they had signaling problems at 400kHz, but
perhaps Benson will rememer.
