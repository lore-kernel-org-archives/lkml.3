Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab3FMPMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 11:12:30 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:57784 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab3FMPM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 11:12:27 -0400
MIME-Version: 1.0
In-Reply-To: <20130613150710.GZ1403@sirena.org.uk>
References: <1369246717-4167-1-git-send-email-nm@ti.com>
	<1369246717-4167-2-git-send-email-nm@ti.com>
	<20130610103131.GR31367@sirena.org.uk>
	<CAGo_u6qTiPpd0DDe3jnPh_UxTwox22azhcMGy=fftL8H+DGeyw@mail.gmail.com>
	<20130610164905.GJ1403@sirena.org.uk>
	<CAGo_u6ov=yaCwt8apbvW57ErAvhgUBHHw9gwADBC1fJUrfucUQ@mail.gmail.com>
	<20130610180150.GQ1403@sirena.org.uk>
	<20130613133950.GA32174@kahuna>
	<20130613144726.GY1403@sirena.org.uk>
	<20130613145803.GA32324@kahuna>
	<20130613150710.GZ1403@sirena.org.uk>
Date: Thu, 13 Jun 2013 10:12:26 -0500
X-Google-Sender-Auth: _-tUlNstoYjRgWdf6wXrnK1Si4M
Message-ID: <CAGo_u6pQ+_N0J8RObxhbgiQBm2tdW4oLziEjiHhqP1WV4HbGsQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/4] regulator: Introduce OMAP regulator to control
 PMIC over VC/VP
From: Nishanth Menon <nm@ti.com>
To: Mark Brown <broonie@kernel.org>
Cc: Paul Walmsley <paul@pwsan.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Tony Lindgren <tony@atomide.com>, devicetree-discuss@lists.ozlabs.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-doc@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 10:07 AM, Mark Brown <broonie@kernel.org> wrote:
> On Thu, Jun 13, 2013 at 09:58:03AM -0500, Nishanth Menon wrote:
>
>> I am proposing moving the following into OF match data.
>> ti,i2c-slave-address
>> ti,i2c-voltage-register
>> ti,i2c-command-register
>> ti,slew-rate-microvolt
>> ti,step-size-micro-volts
>> ti,voltage-selector-set-bits
>> ti,voltage-selector-mask
>> ti,voltage-selector-offset
>> ti,non-zero-voltage-selector
>
>> The only thing I propose to retain is board specific variations - e.g.
>> gpios, boot voltage and standard regulator min,max overrides if any.
>
>> I can also do voltage selector based operations while at it.
>
> OK, this sounds like a step in the right direction.
Thanks for the review and guidance. I will post a new RFC series with
the above changes in a day or so.
Regards,
Nishanth Menon
