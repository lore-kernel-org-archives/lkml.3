Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab3B1AZ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 19:25:27 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:38365 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3B1AZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 19:25:24 -0500
MIME-Version: 1.0
In-Reply-To: <20130227084034.GE16414@sortiz-mobl>
References: <1361830121-32284-1-git-send-email-sjg@chromium.org>
	<CAPnjgZ3enERPu1uK5GW9+_ZinhiDmDuoNn2FGhgVNOZbFVQ0tQ@mail.gmail.com>
	<20130227084034.GE16414@sortiz-mobl>
Date: Wed, 27 Feb 2013 16:25:22 -0800
X-Google-Sender-Auth: KX--gTG_8PKh3Sv4PpuFt8tSpDw
Message-ID: <CAPnjgZ1PMFx-25kD-kyvZy+FC3dM=6U=dgBzctyAicZGfoD35w@mail.gmail.com>
Subject: Re: [PATCH v6 0/6] Add ChromeOS Embedded Controller support
From: Simon Glass <sjg@chromium.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Rob Landley <rob@landley.net>,
        Felipe Balbi <balbi@ti.com>, Grant Likely <grant.likely@secretlab.ca>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Luigi Semenzato <semenzato@chromium.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Che-Liang Chiou <clchiou@chromium.org>,
        Jonathan Kliegman <kliegs@chromium.org>, linux-input@vger.kernel.org,
        Sourav Poddar <sourav.poddar@ti.com>,
        devicetree-discuss@lists.ozlabs.org,
        Alban Bedel <alban.bedel@avionic-design.de>,
        Roland Stigge <stigge@antcom.de>,
        Vincent Palatin <vpalatin@chromium.org>,
        Javier Martinez Canillas <javier@dowhile0.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-doc@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Tony Lindgren <tony@atomide.com>, Bill Pemberton <wfp5p@virginia.edu>,
        Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olofj@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On Wed, Feb 27, 2013 at 12:40 AM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> Hi Simon,
>
> On Tue, Feb 26, 2013 at 09:13:06PM -0800, Simon Glass wrote:
>> Hi Samuel,
>>
>> On Mon, Feb 25, 2013 at 2:08 PM, Simon Glass <sjg@chromium.org> wrote:
>> > The ChromeOS Embedded Controller (EC) is an Open Source EC implementation
>> > used on ARM and Intel Chromebooks. Current implementations use a Cortex-M3
>> > connected on a bus (such as I2C, SPI, LPC) to the AP. A separate interrupt
>> > line is used to indicate when the EC needs service.
>> >
>> > Functions performed by the EC vary by platform, but typically include
>> > battery charging, keyboard scanning and power sequencing.
>> >
>> > This series includes support for the EC message protocol, and implements
>> > a matrix keyboard handler for Linux using the protocol. The EC performs
>> > key scanning and passes scan data in response to AP requests. This is
>> > used on the Samsung ARM Chromebook. No driver is available for LPC at
>> > present.
>> >
>> > This series can in principle operate on any hardware, but for it to actually
>> > work on the Samsung ARM Chromebook, it needs patches which are currently in
>> > progress to mainline: Exynos FDT interrupt support and I2C bus arbitration.
>> >
>> > The driver is device-tree-enabled and a suitable binding is included in
>> > this series. Example device tree nodes are included in the examples,
>> > but no device tree patch for exynos5250-snow is provided at this stage, since
>> > we must wait for the above-mentioned patches to land to avoid errors from
>> > dtc. This can be added with a follow-on patch when that work is complete.
>> >
>>
>> Are you happy with this series? Do you think it is ready to be picked
>> up for mfd?
> It probably is, and it will be part of the next merge window. I'll apply the
> after the merge window closes.

Thank you.

Regards,
Simon

>
> Cheers,
> Samuel.
>
> --
> Intel Open Source Technology Centre
> http://oss.intel.com/
