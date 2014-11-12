Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbaKLOEs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 09:04:48 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:64901 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbaKLOEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 09:04:45 -0500
MIME-Version: 1.0
In-Reply-To: <54636763.10605@ti.com>
References: <1415051968-4878-1-git-send-email-marek@goldelico.com>
	<1415051968-4878-2-git-send-email-marek@goldelico.com>
	<54636763.10605@ti.com>
Date: Wed, 12 Nov 2014 15:04:41 +0100
Message-ID: <CAAfyv34dZBrss5cQJKq=gYUuYb3i7c2cKOyw_QezEuaG3UsodQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] video: omapdss: Add opa362 driver
From: Belisko Marek <marek.belisko@gmail.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-fbdev@vger.kernel.org,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomi,

On Wed, Nov 12, 2014 at 2:57 PM, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
> Hi,
>
>
> On 03/11/14 23:59, Marek Belisko wrote:
>> opa362 is amplifier for videoand can be connected to the tvout pads
>> of the OMAP3. It has one gpio control for enable/disable of the output
>> (high impedance).
>>
>> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
>> ---
>>  drivers/video/fbdev/omap2/displays-new/Kconfig     |   6 +
>>  drivers/video/fbdev/omap2/displays-new/Makefile    |   1 +
>>  .../fbdev/omap2/displays-new/amplifier-opa362.c    | 347 +++++++++++++++++++++
>>  3 files changed, 354 insertions(+)
>>  create mode 100644 drivers/video/fbdev/omap2/displays-new/amplifier-opa362.c
>
> This doesn't even compile:
>
> drivers/video/fbdev/omap2/displays-new/amplifier-opa362.c:207:28: error:
> dereferencing pointer to incomplete type
>   ddata->enable_gpio = pdata->enable_gpio;
Hmm sorry about that. I must mixed something up. I'll post updated version soon.
Thanks for review.
>
> And it seems to have fields for bypass and bypass which are handled in
> the devconf1 patch.
>
>  Tomi
>
>

BR,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
