Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbaEGHVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 03:21:41 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:38060 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbaEGHVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 03:21:38 -0400
MIME-Version: 1.0
In-Reply-To: <5369DAC6.6050608@ti.com>
References: <1398284120-4986-1-git-send-email-marek@goldelico.com>
	<1398284120-4986-3-git-send-email-marek@goldelico.com>
	<5369DAC6.6050608@ti.com>
Date: Wed, 7 May 2014 09:21:38 +0200
Message-ID: <CAAfyv36L_vh+iwrqsePsF8oOxOJ=JXUAk2nJ6F120w+0ivAn8w@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] ARM: dts: oma3-gta04: Add display support
From: Belisko Marek <marek.belisko@gmail.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, rdunlap@infradead.org,
        Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-fbdev@vger.kernel.org,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomi,

On Wed, May 7, 2014 at 9:03 AM, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
> On 23/04/14 23:15, Marek Belisko wrote:
>> This patch add support for lcd display on gta04 board. Display control
>> is connected on spi (used spi bitbang driver).
>>
>> Signed-off-by: Marek Belisko <marek@goldelico.com>
>> ---
>>  arch/arm/boot/dts/omap3-gta04.dts | 86 +++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 86 insertions(+)
>
> <snip>
>
>> +&dss {
>> +     pinctrl-names = "default";
>> +     pinctrl-0 = < &dss_dpi_pins >;
>> +
>> +     status = "okay";
>> +
>> +     vdds_dsi-supply = <&vpll2>;
>> +
>> +     dpi_out: endpoint {
>> +               remote-endpoint = <&lcd_in>;
>> +               data-lines = <24>;
>> +       };
>> +
>> +};
>>
>
> Did you try this on 3.15-rc? The above is not right, and I don't think
> it works. You need 'port' node for the dpi_out endpoint.
This patches was tested against 3.15 series and it works. I'l recheck.
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
