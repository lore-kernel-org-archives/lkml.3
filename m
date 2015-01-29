Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719AbbA2Ppk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 10:45:40 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:42529 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbbA2Ppj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 10:45:39 -0500
Date: Thu, 29 Jan 2015 15:45:38 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Rob Herring <robherring2@gmail.com>
cc: Mark Rutland <mark.rutland@arm.com>, Alexandre Courbot <gnurou@gmail.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 02/24] Documentation: DT bindings: add more chip compatible
 strings for Tegra PCIe
In-Reply-To: <CAL_JsqKMm=r+57ShskgbtNqnCGF1yKYDSJJFQ7o05keNzh5z+g@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1501291543030.16475@utopia.booyaka.com>
References: <20150128234935.20644.89300.stgit@dusk.lan> <20150128234937.20644.9400.stgit@dusk.lan> <CAL_JsqKMm=r+57ShskgbtNqnCGF1yKYDSJJFQ7o05keNzh5z+g@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob

On Thu, 29 Jan 2015, Rob Herring wrote:

> On Wed, Jan 28, 2015 at 5:49 PM, Paul Walmsley <paul@pwsan.com> wrote:
> >
> > Add compatible strings for the PCIe IP blocks present on several Tegra
> > chips.  The primary objective here is to avoid checkpatch warnings,
> > per:
> >
> > http://marc.info/?l=linux-tegra&m=142201349727836&w=2
> >
> > Signed-off-by: Paul Walmsley <paul@pwsan.com>
> > Cc: Thierry Reding <thierry.reding@gmail.com>
> > Cc: Rob Herring <robh+dt@kernel.org>
> > Cc: Pawel Moll <pawel.moll@arm.com>
> > Cc: Mark Rutland <mark.rutland@arm.com>
> > Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
> > Cc: Kumar Gala <galak@codeaurora.org>
> > Cc: Stephen Warren <swarren@wwwdotorg.org>
> > Cc: Alexandre Courbot <gnurou@gmail.com>
> > Cc: linux-tegra@vger.kernel.org
> > Cc: linux-pci@vger.kernel.org
> > Cc: devicetree@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > ---
> >  .../bindings/pci/nvidia,tegra20-pcie.txt           |    2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/Documentation/devicetree/bindings/pci/nvidia,tegra20-pcie.txt b/Documentation/devicetree/bindings/pci/nvidia,tegra20-pcie.txt
> > index d763e047c6ae..e772884f1c33 100644
> > --- a/Documentation/devicetree/bindings/pci/nvidia,tegra20-pcie.txt
> > +++ b/Documentation/devicetree/bindings/pci/nvidia,tegra20-pcie.txt
> > @@ -5,6 +5,8 @@ Required properties:
> >    - "nvidia,tegra20-pcie"
> >    - "nvidia,tegra30-pcie"
> >    - "nvidia,tegra124-pcie"
> > +  - "nvidia,tegra132-pcie" (not yet matched in the driver)
> > +  - "nvidia,tegra210-pcie" (not yet matched in the driver)
> 
> Whether the driver matches or not is irrelevant to the binding and may
> change over time. Does this mean the driver matches on something else
> or Tegra132 is not yet supported in the driver? 

It means that the driver currently matches on one of the first three 
strings that don't carry that annotation.

> If the former, what is important is what are the valid combinations of 
> compatible properties and that is not captured here. In other words, 
> what is the fallback compatible string for each chip?

The intention was to try to be helpful: to document that anyone adding a 
"nvidia,tegra132-pcie" compatible string would also need to add one of the 
other strings as a fallback.  Would you like that to be documented in a 
different way, or removed?


- Paul
