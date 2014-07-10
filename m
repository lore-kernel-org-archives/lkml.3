Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbaGJNZp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 09:25:45 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:61772 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbaGJNZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 09:25:42 -0400
Date: Thu, 10 Jul 2014 14:25:34 +0100
From: Lee Jones <lee.jones@linaro.org>
To: amit daniel kachhap <amit.daniel@samsung.com>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Tushar Behera <trblinux@gmail.com>, Andreas Farber <afaerber@suse.de>,
        LAK <linux-arm-kernel@lists.infradead.org>, devicetree@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 15/23] regulator: max77686: Setup DVS-related GPIOs on
 probe
Message-ID: <20140710132534.GD11948@lee--X1>
References: <1404467722-26687-1-git-send-email-javier.martinez@collabora.co.uk>
 <1404467722-26687-16-git-send-email-javier.martinez@collabora.co.uk>
 <CADGdYn4EURaHinWVksQSPzVr=CkZYcrqvWsO7mKDz_gY9XB__Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADGdYn4EURaHinWVksQSPzVr=CkZYcrqvWsO7mKDz_gY9XB__Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2014, amit daniel kachhap wrote:

> On Fri, Jul 4, 2014 at 3:25 PM, Javier Martinez Canillas
> <javier.martinez@collabora.co.uk> wrote:
> > MAX77686 PMIC support Dyamic Voltage Scaling (DVS) on a set
> > of Buck regulators. A number of GPIO are connected to these
> > lines and are requested by the mfd driver. Setup the GPIO
> > pins from the regulator driver.

> If possible merge this patch with patch 8. Both are adding DVS
> support. Put regmap_copy dependency patch in very beginning.

You want to merge two patches which deal with different subsystems?

That's the opposite of what we usually try and achieve.

> > Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> > ---
> >  drivers/regulator/max77686.c | 34 ++++++++++++++++++++++++++++++++++
> >  1 file changed, 34 insertions(+)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
