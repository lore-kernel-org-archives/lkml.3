Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbbA2OqD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 09:46:03 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:35126 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbbA2OqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 09:46:00 -0500
MIME-Version: 1.0
In-Reply-To: <20150128234937.20644.9400.stgit@dusk.lan>
References: <20150128234935.20644.89300.stgit@dusk.lan> <20150128234937.20644.9400.stgit@dusk.lan>
From: Rob Herring <robherring2@gmail.com>
Date: Thu, 29 Jan 2015 08:45:37 -0600
Message-ID: <CAL_JsqKMm=r+57ShskgbtNqnCGF1yKYDSJJFQ7o05keNzh5z+g@mail.gmail.com>
Subject: Re: [PATCH 02/24] Documentation: DT bindings: add more chip
 compatible strings for Tegra PCIe
To: Paul Walmsley <paul@pwsan.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Alexandre Courbot <gnurou@gmail.com>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 5:49 PM, Paul Walmsley <paul@pwsan.com> wrote:
>
> Add compatible strings for the PCIe IP blocks present on several Tegra
> chips.  The primary objective here is to avoid checkpatch warnings,
> per:
>
> http://marc.info/?l=linux-tegra&m=142201349727836&w=2
>
> Signed-off-by: Paul Walmsley <paul@pwsan.com>
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
> Cc: Kumar Gala <galak@codeaurora.org>
> Cc: Stephen Warren <swarren@wwwdotorg.org>
> Cc: Alexandre Courbot <gnurou@gmail.com>
> Cc: linux-tegra@vger.kernel.org
> Cc: linux-pci@vger.kernel.org
> Cc: devicetree@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  .../bindings/pci/nvidia,tegra20-pcie.txt           |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/pci/nvidia,tegra20-pcie.txt b/Documentation/devicetree/bindings/pci/nvidia,tegra20-pcie.txt
> index d763e047c6ae..e772884f1c33 100644
> --- a/Documentation/devicetree/bindings/pci/nvidia,tegra20-pcie.txt
> +++ b/Documentation/devicetree/bindings/pci/nvidia,tegra20-pcie.txt
> @@ -5,6 +5,8 @@ Required properties:
>    - "nvidia,tegra20-pcie"
>    - "nvidia,tegra30-pcie"
>    - "nvidia,tegra124-pcie"
> +  - "nvidia,tegra132-pcie" (not yet matched in the driver)
> +  - "nvidia,tegra210-pcie" (not yet matched in the driver)

Whether the driver matches or not is irrelevant to the binding and may
change over time. Does this mean the driver matches on something else
or Tegra132 is not yet supported in the driver? If the former, what is
important is what are the valid combinations of compatible properties
and that is not captured here. In other words, what is the fallback
compatible string for each chip?

The same comments apply to the rest of the series.

Rob
