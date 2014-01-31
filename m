Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933121AbaAaSVA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 13:21:00 -0500
Received: from mail-ve0-f179.google.com ([209.85.128.179]:39857 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932564AbaAaSU6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 13:20:58 -0500
MIME-Version: 1.0
In-Reply-To: <2809570.RstiYk4HG8@phil>
References: <2809570.RstiYk4HG8@phil>
Date: Fri, 31 Jan 2014 12:20:57 -0600
Message-ID: <CAL_JsqJmFK0H15JbogMP+vTYE7xTijUGwOZNLkzkd7pVRBNROg@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: add vendor-prefix for neonode
From: Rob Herring <robherring2@gmail.com>
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 8:18 AM, Heiko Stübner <heiko@sntech.de> wrote:
> From: Heiko Stuebner <heiko.stuebner@bqreaders.com>
>
> Neonode Inc. is the Manufacturer of the zforce infraread touchscreens
> used in a lot of ebook readers and supported by the zforce_ts driver.
>
> Signed-off-by: Heiko Stuebner <heiko.stuebner@bqreaders.com>
> ---
> Dmitry, the input maintainer, didn't want to carry the vendor-prefix
> addition [0], therefore add it separately.

Applied.

Rob

>
> [0] http://permalink.gmane.org/gmane.linux.kernel.input/33887
>
>  Documentation/devicetree/bindings/vendor-prefixes.txt |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
> index edbb8d8..32a60a9 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -47,6 +47,7 @@ maxim Maxim Integrated Products
>  microchip      Microchip Technology Inc.
>  mosaixtech     Mosaix Technologies, Inc.
>  national       National Semiconductor
> +neonode                Neonode Inc.
>  nintendo       Nintendo
>  nvidia NVIDIA
>  nxp    NXP Semiconductors
> --
> 1.7.10.4
>
>
