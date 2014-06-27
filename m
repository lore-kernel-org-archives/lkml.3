Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbaF0Hx0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 03:53:26 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:33725 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069AbaF0HxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 03:53:24 -0400
Message-ID: <53AD22ED.5040303@collabora.co.uk>
Date: Fri, 27 Jun 2014 09:53:17 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Andreas_F=E4rber?= <afaerber@suse.de>,
        Lee Jones <lee.jones@linaro.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Stone <daniels@collabora.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 03/14] clk: max77686: Add DT include for MAX77686 PMIC
 clock
References: <1403806546-31122-1-git-send-email-javier.martinez@collabora.co.uk> <1403806546-31122-4-git-send-email-javier.martinez@collabora.co.uk> <53AD21E5.1030609@suse.de>
In-Reply-To: <53AD21E5.1030609@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andreas,

On 06/27/2014 09:48 AM, Andreas Färber wrote:
> Am 26.06.2014 20:15, schrieb Javier Martinez Canillas:
>> This patch adds a dt-binding include for Maxim 77686
>> PMIC clock IDs that can be to be shared between the
> 
> "can be shared"?
> 

As it should be quite clear right now I'm not a native English speaker. I meant
that the header file can be included by both Device Tree source files and the
max77802 driver.

> Regards,
> Andreas
> 

Best regards,
Javier
