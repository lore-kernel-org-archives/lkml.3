Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbaKLLqb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 06:46:31 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:46957 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbaKLLq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 06:46:27 -0500
MIME-Version: 1.0
In-Reply-To: <CABgxDoLfGYRnGCLmxnW6XCwJo3AoecO3=sLNBsOUAHig3P8New@mail.gmail.com>
References: <1415283784-10885-1-git-send-email-romain.perier@gmail.com>
 <1415283784-10885-2-git-send-email-romain.perier@gmail.com>
 <20141111150139.A904BC416AF@trevor.secretlab.ca> <CABgxDoLfGYRnGCLmxnW6XCwJo3AoecO3=sLNBsOUAHig3P8New@mail.gmail.com>
From: Grant Likely <grant.likely@linaro.org>
Date: Wed, 12 Nov 2014 11:46:06 +0000
X-Google-Sender-Auth: 82k_dxmfGr_UfxLa_QexNAGNdCw
Message-ID: <CACxGe6tiv8io4Bv+O6uSsGGwZ87R-_j965qhbQdBexOHakk4Pg@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] of: Rename "poweroff-source" property to "system-power-controller"
To: Romain Perier <romain.perier@gmail.com>
Cc: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Rob Herring <robh+dt@kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Johan Hovold <johan@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Felipe Balbi <balbi@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 7:01 PM, Romain Perier <romain.perier@gmail.com> wrote:
> 2014-11-11 16:01 GMT+01:00 Grant Likely <grant.likely@linaro.org>:
>> So, to be a little pendantic, the 'ti,' prefix is basically just for
>> backwards compatibility with the old binding, and that old binding is
>> only used on palmas.c, tps65*.c and twl4030-power.c, correct?
>
> No, the backward compatibility here is only useful for drivers which
> used "ti,system-power-controller" in the past and recently switched to
> the new property through the standard helper function. As most of the
> dts were not updated to use the new property, previous patches broke
> compatibility with "ti,system-power-controller" (this compat would be
> reverted with this serie). Only one driver has this problem, it is
> tps65910.
>
> So, What you propose is that I should handle the old property directly
> from tps65910, and keep the standard helper generic right ?

yes as it is a quirk for only that driver.

g.
