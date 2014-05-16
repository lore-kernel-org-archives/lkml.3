Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894AbaEPKFn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 06:05:43 -0400
Received: from gloria.sntech.de ([95.129.55.99]:53960 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756596AbaEPKFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 06:05:41 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Beniamino Galvani <b.galvani@gmail.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v2 1/2] of: add mundoreader and radxa vendor prefixes
Date: Fri, 16 May 2014 12:09:04 +0200
Message-ID: <2536935.asXUKXC7IY@phil>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1399396211-25353-1-git-send-email-b.galvani@gmail.com>
References: <1399396211-25353-1-git-send-email-b.galvani@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Beniamino,

Am Dienstag, 6. Mai 2014, 19:10:10 schrieb Beniamino Galvani:
> Add new vendor prefixes for:
> 
>     * Mundo Reader S.L., a company that produces tablets and e-readers
>     * Radxa, manufacturer of ARM boards
> 
> Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>

Just FYI, I've sent both patches off, as part of my dt changes pull request on 
monday.


Heiko

> ---
> 
> v2:
>  - use mundoreader prefix instead of bq as suggested by Heiko Stuebner
> 
>  Documentation/devicetree/bindings/vendor-prefixes.txt |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt
> b/Documentation/devicetree/bindings/vendor-prefixes.txt index
> abc3080..53bd92f 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -79,6 +79,7 @@ microchip	Microchip Technology Inc.
>  mosaixtech	Mosaix Technologies, Inc.
>  moxa	Moxa
>  mpl	MPL AG
> +mundoreader	Mundo Reader S.L.
>  mxicy	Macronix International Co., Ltd.
>  national	National Semiconductor
>  neonode		Neonode Inc.
> @@ -98,6 +99,7 @@ powervr	PowerVR (deprecated, use img)
>  qca	Qualcomm Atheros, Inc.
>  qcom	Qualcomm Technologies, Inc
>  qnap	QNAP Systems, Inc.
> +radxa	Radxa
>  raidsonic	RaidSonic Technology GmbH
>  ralink	Mediatek/Ralink Technology Corp.
>  ramtron	Ramtron International

