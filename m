Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbaHSMyY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 08:54:24 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:42354 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbaHSMyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 08:54:22 -0400
Message-ID: <53F348F5.8040800@collabora.co.uk>
Date: Tue, 19 Aug 2014 14:54:13 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: Mark Brown <broonie@kernel.org>, Tim Kryger <tim.kryger@gmail.com>,
        Chris Ball <chris@printf.net>, Seungwon Jeon <tgih.jun@samsung.com>,
        Haijun Zhang <Haijun.Zhang@freescale.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] mmc: core: Use regulator_get_voltage() if OCR mask
 is empty.
References: <1408019940-11153-1-git-send-email-javier.martinez@collabora.co.uk>	<CAD7vxxKvzxvmzgx=S5ZZn54ts99ca2TqBYFvY1SXZQZDkhjq3w@mail.gmail.com>	<20140814151958.GY17528@sirena.org.uk>	<CAD7vxxLHtk2ywHGoBtDp6x3-5BtDdaFnCdc_pfgMwq63Cg8Qow@mail.gmail.com>	<53EDBB5B.4000209@collabora.co.uk>	<20140815095528.GH17528@sirena.org.uk>	<CAPDyKFpm5nzXp5p0qxDof2NcOML911eYkjPNMsn9a2ttdnW7gQ@mail.gmail.com>	<53F3351C.1020500@collabora.co.uk> <CAPDyKFrW1ZojV0sWTswapWDvkmgshtyb=NP9CrY+GymdQeRq5w@mail.gmail.com>
In-Reply-To: <CAPDyKFrW1ZojV0sWTswapWDvkmgshtyb=NP9CrY+GymdQeRq5w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2014 02:43 PM, Ulf Hansson wrote:
> 
> Well, currently this seems like the best approach. If we end up having
> some new regulator helper function, future wise, we can convert to
> such later on.
>

Great, thanks a lot for your help!

> Kind regards
> Uffe
> 

Best regards,
Javier
