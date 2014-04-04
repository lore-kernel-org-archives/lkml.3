Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbaDDDBs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 23:01:48 -0400
Received: from mail-yh0-f43.google.com ([209.85.213.43]:42392 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbaDDDBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 23:01:44 -0400
MIME-Version: 1.0
In-Reply-To: <20140403210135.GX14763@sirena.org.uk>
References: <ee057d8c-50d9-4d4b-ac86-d7c5fc44b1b0@TX2EHSMHS034.ehs.local>
	<20140403210135.GX14763@sirena.org.uk>
Date: Fri, 4 Apr 2014 08:31:43 +0530
Message-ID: <CAFcVEC+sqB9VQUEgiFN_MwHcvYFqEifh6EuHPLAkKZOnBiaQ9A@mail.gmail.com>
Subject: Re: [PATCH 1/2] devicetree: Add devicetree bindings documentation for
 Zynq Quad SPI
From: Harini Katakam <harinikatakamlinux@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, linux-spi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Punnaiah Choudary <kpc528@gmail.com>,
        punnaiah choudary kalluri <kalluripunnaiahchoudary@gmail.com>,
        Punnaiah Choudary Kalluri <punnaia@xilinx.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, Apr 4, 2014 at 2:31 AM, Mark Brown <broonie@kernel.org> wrote:
> On Thu, Apr 03, 2014 at 10:33:06PM +0530, Punnaiah Choudary Kalluri wrote:
>
>> +Optional properties:
>> +- num-cs             : Number of chip selects used.
>
> What does this translate into?
>
>> +             num-cs = /bits/ 16 <1>;
>
> Why the odd specification in the example - why not just specify it as a
> number?

Same as discussed on SPI cadence thread.

Regards,
Harini
