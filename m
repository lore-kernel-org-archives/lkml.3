Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944AbaHGBtc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 21:49:32 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:35193 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258AbaHGBta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 21:49:30 -0400
Message-ID: <53E2DB24.7050305@collabora.co.uk>
Date: Thu, 07 Aug 2014 03:49:24 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>
CC: Kukjin Kim <kgene.kim@samsung.com>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, Stephen Warren <swarren@nvidia.com>,
        Yufeng Shen <miletus@chromium.org>, Benson Leung <bleung@chromium.org>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        linux-input@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] ARM: dts: Add Peach Pit and Pi dts entry for atmel
 touchpad
References: <1407373713-26281-1-git-send-email-javier.martinez@collabora.co.uk> <CAOMZO5CsUKuAcDMzHhy32457ihGqEBTdUijDbwA7QwUqq-ukbQ@mail.gmail.com>
In-Reply-To: <CAOMZO5CsUKuAcDMzHhy32457ihGqEBTdUijDbwA7QwUqq-ukbQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Fabio,

On 08/07/2014 03:35 AM, Fabio Estevam wrote:
> On Wed, Aug 6, 2014 at 10:08 PM, Javier Martinez Canillas
> <javier.martinez@collabora.co.uk> wrote:
> 
>> +&hsi2c_8 {
>> +       status = "okay";
>> +       clock-frequency = <333000>;
> 
> Doesn't it work at the more standard 400kHz i2c frequency?
> 

Most bits of this DTS snippet have been taken from the downstream Chrome OS 3.8
kernel so I'll let one of the Chromium folks to answer this question.

Best regards,
Javier
