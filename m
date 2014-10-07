Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbaJGQeK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 12:34:10 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:35673 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbaJGQeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 12:34:09 -0400
MIME-Version: 1.0
In-Reply-To: <1412695169-22815-3-git-send-email-darshanapadmadas@gmail.com>
References: <1412695169-22815-1-git-send-email-darshanapadmadas@gmail.com> <1412695169-22815-3-git-send-email-darshanapadmadas@gmail.com>
From: Rob Herring <robherring2@gmail.com>
Date: Tue, 7 Oct 2014 11:33:46 -0500
Message-ID: <CAL_JsqKBmwgYF1iQQ_0SzkR9MJZyFj214Je148ONxUh02ZftVg@mail.gmail.com>
Subject: Re: [PATCH v4 2/4] Documentation: devicetree: bindings: Document
 deprecated device vendor name to fix related warning
To: Darshana Padmadas <darshanapadmadas@gmail.com>
Cc: opw-kernel@googlegroups.com, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jonathan Cameron <jic23@kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 7, 2014 at 10:19 AM, Darshana Padmadas
<darshanapadmadas@gmail.com> wrote:
> This patch documents deprecated vendor name of device isl29028 for compatibility with older kernels.

Fix your line wrapping to 72 chars.

You can shorten the subject "Documentation: devicetree: bindings:" to
"dt-bindings:". We're horribly inconsistent there...

Rob

> Signed-off-by: Darshana Padmadas <darshanapadmadas@gmail.com>
> ---
>  Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
> index ac7269f..ab97459 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -68,6 +68,7 @@ img   Imagination Technologies Ltd.
>  intel  Intel Corporation
>  intercontrol   Inter Control Group
>  isee   ISEE 2007 S.L.
> +isil    Intersil (deprecated, use isl)
>  isl    Intersil
>  karo   Ka-Ro electronics GmbH
>  keymile        Keymile GmbH
> --
> 1.9.1
>
