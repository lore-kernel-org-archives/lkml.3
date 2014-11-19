Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbaKSIGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 03:06:46 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:50140 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754976AbaKSIGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 03:06:45 -0500
MIME-Version: 1.0
In-Reply-To: <1416321575-18348-2-git-send-email-edubezval@gmail.com>
References: <1416321575-18348-1-git-send-email-edubezval@gmail.com> <1416321575-18348-2-git-send-email-edubezval@gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Wed, 19 Nov 2014 17:06:24 +0900
Message-ID: <CAAVeFu+aUdpV_hj50TAZDO_5JgRmPH2RtJuP7Qozx4RNEzO-6A@mail.gmail.com>
Subject: Re: [PATCHv4 1/1] thermal: of: improve of-thermal sensor registration API
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Linux PM <linux-pm@vger.kernel.org>,
        Caesar Wang <caesar.wang@rock-chips.com>, Wei Ni <wni@nvidia.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Mikko Perttunen <mikko.perttunen@kapsi.fi>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>, Jean Delvare <jdelvare@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        lm-sensors@lm-sensors.org, Rob Herring <robh+dt@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Zhang Rui <rui.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 11:39 PM, Eduardo Valentin <edubezval@gmail.com> wrote:
> Different drivers request API extensions in of-thermal. For this reason,
> additional callbacks are required to fit the new drivers needs.
>
> The current API implementation expects the registering sensor driver
> to provide a get_temp and get_trend callbacks as function parameters.
> As the amount of callbacks is growing, this patch changes the existing
> implementation to use a .ops field to hold all the of thermal callbacks
> to sensor drivers.
>
> This patch also changes the existing of-thermal users to fit the new
> API design. No functional change is introduced in this patch.

A good idea even if no ops were to be added!

Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
