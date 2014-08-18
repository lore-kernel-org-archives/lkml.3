Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336AbaHRVop (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 17:44:45 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:41972 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbaHRVon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 17:44:43 -0400
Message-ID: <53F27395.5070601@collabora.co.uk>
Date: Mon, 18 Aug 2014 23:43:49 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Kukjin Kim <kgene.kim@samsung.com>, Doug Anderson <dianders@chromium.org>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RESEND PATCH 1/2] ARM: dts: Improve Peach Pit and Pi power scheme
References: <1407757091-18730-1-git-send-email-javier.martinez@collabora.co.uk> <CAD=FV=UbckfwGucuPjEtHixVgF5K2fD5N3EPS2BH96DRDACuqw@mail.gmail.com> <53F245A4.5010106@samsung.com>
In-Reply-To: <53F245A4.5010106@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kukjin,

On 08/18/2014 08:27 PM, Kukjin Kim wrote:
> On 08/11/14 10:46, Doug Anderson wrote:
>>
> OK, I've applied this but 2nd in this series...
>

Thanks for picking this and yes PATCH 2/2 from this series was dropped.

>> Acked-by: Doug Anderson<dianders@chromium.org>
>>
> Thanks,
> Kukjin
> 

I've posted PATCH "mmc: core: Use regulator_get_voltage() if OCR mask is
empty." [0] instead to solve the issue that patch 2/2 tried to address.

Best regards,
Javier

[0]: https://lkml.org/lkml/2014/8/14/200
