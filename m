Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030274AbaFXQnX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 12:43:23 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:59832 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450AbaFXQnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 12:43:20 -0400
Message-ID: <53A9AAA1.4030005@collabora.co.uk>
Date: Tue, 24 Jun 2014 18:43:13 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Stone <daniels@collabora.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 07/10] regulator: Add driver for Maxim 77802 PMIC regulators
References: <1402941758-11216-1-git-send-email-javier.martinez@collabora.co.uk> <1402941758-11216-8-git-send-email-javier.martinez@collabora.co.uk> <20140616192500.GJ5099@sirena.org.uk> <53A01D54.10506@collabora.co.uk> <20140617141254.GP5099@sirena.org.uk> <53A06749.1010606@collabora.co.uk> <20140621204026.GH22657@sirena.org.uk> <53A7F339.7050608@collabora.co.uk> <20140623094734.GV24291@sirena.org.uk>
In-Reply-To: <20140623094734.GV24291@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

On 06/23/2014 11:47 AM, Mark Brown wrote:
> On Mon, Jun 23, 2014 at 11:28:25AM +0200, Javier Martinez Canillas wrote:
>> On 06/21/2014 10:40 PM, Mark Brown wrote:
> 
>> > That's not really relevant here - I'm asking if the regulators get their
>> > own supplies rather than if anything uses them.
> 
>> Sorry if I keep misunderstanding your question but the regulators in this PMIC
>> don't have a parent supply/regulator node.
> 
> They should, I'm pretty sure the device does actually regulate one
> supply into another.
> 

Thanks a lot for the clarification. This was not evident to me when I read the
PMIC datasheet and because both the max77xxx Chrome OS 3.8 and mainline max77686
drivers used a simplistic model of the power scheme.

But Doug confirmed to me that some regulators on this PMIC do indeed use others
regulators as a power supply so I'll change this in the next version of the
patch-set.

Best regards,
Javier
