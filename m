Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910AbaKRSIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 13:08:21 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:34674 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbaKRSIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 13:08:18 -0500
MIME-Version: 1.0
In-Reply-To: <A765B125120D1346A63912DDE6D8B6315EB8F8@NTXXIAMBX02.xacn.micron.com>
References: <A765B125120D1346A63912DDE6D8B6315EB8F8@NTXXIAMBX02.xacn.micron.com>
From: Rob Herring <robherring2@gmail.com>
Date: Tue, 18 Nov 2014 12:07:57 -0600
Message-ID: <CAL_JsqLeUnVoS1ThzK3hpQBrjUxOXVL4gCpQRXBYjZ_ts6WtFg@mail.gmail.com>
Subject: Re: [V3 PATCH 1/1] devicetree: bindings: Add vendor prefix for Micron
 Technology Co., Ltd.
To: bpqw <bpqw@micron.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jason Cooper <jason@lakedaemon.net>,
        Mark Brown <broonie@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        Thierry Reding <treding@nvidia.com>,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        Andrew Lunn <andrew@lunn.ch>, Silvio F <silvio.fricke@gmail.com>,
        Hayato Suzuki <hytszk@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 8:26 AM, bpqw <bpqw@micron.com> wrote:
> This patch is used to add vendor prefix for Micron Technology Inc in the
> vendor-prefixes.txt file.
>
> Micron Technology,Inc.is an American multinational corporation based in Boise,
> Idaho,best known for producing many forms of semiconductor devices.This includes
> DRAM,SDRAM,flash memory,eMMC and SSDs.
>
> Signed-off-by: Bean Huo <bpqw@micron.com>

Applied, thanks.

Rob

> ---
> V2:
>   - Add signed-off-by
>   - Modify commit logs that wrapped to less than 80 columns
> V3:
>   - Remove the same signed-off-by owner's mailbox
>   - Modify proper name of signed-off-by
>
>  .../devicetree/bindings/vendor-prefixes.txt        |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
> index 723999d..a7bbf6e 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -92,6 +92,7 @@ maxim Maxim Integrated Products
>  mediatek       MediaTek Inc.
>  micrel Micrel Inc.
>  microchip      Microchip Technology Inc.
> +micron Micron Technology Inc.
>  mitsubishi     Mitsubishi Electric Corporation
>  mosaixtech     Mosaix Technologies, Inc.
>  moxa   Moxa
> --
> 1.7.9.5
