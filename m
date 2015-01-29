Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020AbbA2OhU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 09:37:20 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:44464 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878AbbA2OhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 09:37:18 -0500
MIME-Version: 1.0
In-Reply-To: <20150128234938.20644.69989.stgit@dusk.lan>
References: <20150128234935.20644.89300.stgit@dusk.lan> <20150128234938.20644.69989.stgit@dusk.lan>
From: Rob Herring <robherring2@gmail.com>
Date: Thu, 29 Jan 2015 08:36:56 -0600
Message-ID: <CAL_JsqJq8D86gUdw80Nev=zmW=kYR90iNKiTzciwpaGx2qNJsA@mail.gmail.com>
Subject: Re: [PATCH 24/24] Documentation: DT bindings: add nvidia, denver
 compatible string
To: Paul Walmsley <paul@pwsan.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Heiko Stuebner <heiko@sntech.de>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rohit Vaswani <rvaswani@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marc Carino <marc.ceeeee@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Paul Walmsley <pwalmsley@nvidia.com>,
        Kumar Gala <galak@codeaurora.org>, Olof Johansson <olof@lixom.net>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 5:49 PM, Paul Walmsley <paul@pwsan.com> wrote:
>
> Add a compatible string for the NVIDIA Denver CPU to the ARM CPU DT
> binding documentation file.  The primary objective here is to keep
> checkpatch.pl from warning when the compatible string is used in an
> SoC DT file, per:
>
> http://marc.info/?l=linux-tegra&m=142201349727836&w=2
>
>
> Signed-off-by: Paul Walmsley <paul@pwsan.com>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
> Cc: Kumar Gala <galak@codeaurora.org>
> Cc: Heiko Stuebner <heiko@sntech.de>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
> Cc: Rohit Vaswani <rvaswani@codeaurora.org>
> Cc: Paul Walmsley <pwalmsley@nvidia.com>
> Cc: Marc Carino <marc.ceeeee@gmail.com>
> Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> Cc: devicetree@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> ---
>  Documentation/devicetree/bindings/arm/cpus.txt |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/Documentation/devicetree/bindings/arm/cpus.txt b/Documentation/devicetree/bindings/arm/cpus.txt
> index b2aacbe16ed9..4ea31f0b7764 100644
> --- a/Documentation/devicetree/bindings/arm/cpus.txt
> +++ b/Documentation/devicetree/bindings/arm/cpus.txt
> @@ -175,6 +175,7 @@ nodes to be present and contain the properties described below.
>                             "marvell,pj4a"
>                             "marvell,pj4b"
>                             "marvell,sheeva-v5"
> +                           "nvidia,denver" (not yet matched in the code)

There's not variations or versions of Denver cores or plans to change
from the codename?

Rob
