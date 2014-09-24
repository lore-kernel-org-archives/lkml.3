Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbaIXRKv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 13:10:51 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41533 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753576AbaIXRKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 13:10:49 -0400
Date: Wed, 24 Sep 2014 18:10:46 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jonathan Cameron <jic23@kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>, Hartmut Knaack <knaack.h@gmx.de>,
        Lee Jones <lee.jones@linaro.org>, Philippe Reynes <tremyfr@yahoo.fr>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v2] iio: iadc: Qualcomm SPMI PMIC current ADC driver
Message-ID: <20140924171046.GM5729@leverpostej>
References: <1411567103-2380-1-git-send-email-iivanov@mm-sol.com>
 <20140924145527.GI5729@leverpostej>
 <1411574442.18580.95.camel@iivanov-dev>
 <20140924170522.GL5729@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924170522.GL5729@leverpostej>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > +
> > > > +- qcom,rsense:
> > > > +    Usage: optional
> > > > +    Value type: <u32>
> > > > +    Definition: External sense register value in Ohm. Defining this
> > > > +            propery will instruct ADC to use external ADC sense channel.
> > > > +            If property is not defined ADC will use internal sense channel.
> > > 
> > > The latter two sentences sound like a driver description.
> > > 
> > > What exactly is the difference between the internal and external
> > > channels, and what exactly is the value in the sense register used for?
> > 
> > Internal - when using chip build-in resistor
> > External - when using off-chip resistor
> 
> Would it be possible to use the internal channel when you have an
> external resistor?
> 
> If so, does the device have a channel per resistor, or can either
> resistor be selected and applied to the single channel the device has?
> 
> This might be better worded as "external-registor-ohms".

I meant to say "external-resistor-ohms".

Muscle memory and lack of coffee got the better of me.

Mark.
