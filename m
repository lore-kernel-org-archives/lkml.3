Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261AbaEFRYE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 13:24:04 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:37594 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbaEFRYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 13:24:01 -0400
MIME-Version: 1.0
In-Reply-To: <1399396211-25353-1-git-send-email-b.galvani@gmail.com>
References: <1399396211-25353-1-git-send-email-b.galvani@gmail.com>
Date: Tue, 6 May 2014 12:24:00 -0500
Message-ID: <CAL_JsqLj04SB0sPeRCQo00wKd5YGX3HG_TFHiUFhqf8VZarvyQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] of: add mundoreader and radxa vendor prefixes
From: Rob Herring <robherring2@gmail.com>
To: Beniamino Galvani <b.galvani@gmail.com>
Cc: Heiko Stuebner <heiko@sntech.de>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 6, 2014 at 12:10 PM, Beniamino Galvani <b.galvani@gmail.com> wrote:
> Add new vendor prefixes for:
>
>     * Mundo Reader S.L., a company that produces tablets and e-readers
>     * Radxa, manufacturer of ARM boards
>
> Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>

Acked-by: Rob Herring <robh@kernel.org>

> ---
>
> v2:
>  - use mundoreader prefix instead of bq as suggested by Heiko Stuebner
>
>  Documentation/devicetree/bindings/vendor-prefixes.txt |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
> index abc3080..53bd92f 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -79,6 +79,7 @@ microchip     Microchip Technology Inc.
>  mosaixtech     Mosaix Technologies, Inc.
>  moxa   Moxa
>  mpl    MPL AG
> +mundoreader    Mundo Reader S.L.
>  mxicy  Macronix International Co., Ltd.
>  national       National Semiconductor
>  neonode                Neonode Inc.
> @@ -98,6 +99,7 @@ powervr       PowerVR (deprecated, use img)
>  qca    Qualcomm Atheros, Inc.
>  qcom   Qualcomm Technologies, Inc
>  qnap   QNAP Systems, Inc.
> +radxa  Radxa
>  raidsonic      RaidSonic Technology GmbH
>  ralink Mediatek/Ralink Technology Corp.
>  ramtron        Ramtron International
> --
> 1.7.10.4
>
