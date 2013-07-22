Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932719Ab3GVR4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 13:56:18 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:44468 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114Ab3GVR4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 13:56:16 -0400
Message-ID: <51ED804E.1000701@kernel.org>
Date: Mon, 22 Jul 2013 19:56:14 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Oleksandr Kravchenko <x0199363@ti.com>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, grant.likely@linaro.org,
        rob.herring@calxeda.com, rob@landley.net, jic23@cam.ac.uk,
        pmeerw@pmeerw.net, holler@ahsoftware.de, srinivas.pandruvada@intel.com,
        devicetree-discuss@lists.ozlabs.org, grygorii.strashko@ti.com,
        Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
Subject: Re: [PATCH v3 1/2] of: Add Avago Technologies vendor prefix
References: <1374498688-24701-1-git-send-email-x0199363@ti.com>
In-Reply-To: <1374498688-24701-1-git-send-email-x0199363@ti.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/13 14:11, Oleksandr Kravchenko wrote:
> From: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
> 
> This commit adds a device tree vendor prefix for Avago Technologies.
> 
> Signed-off-by: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
applied to the togreg branch of iio.git
Thanks

> ---
>  .../devicetree/bindings/vendor-prefixes.txt        |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
> index d5a79ca..8aab9c6 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -11,6 +11,7 @@ amcc	Applied Micro Circuits Corporation (APM, formally AMCC)
>  apm	Applied Micro Circuits Corporation (APM)
>  arm	ARM Ltd.
>  atmel	Atmel Corporation
> +avago	Avago Technologies
>  bosch	Bosch Sensortec GmbH
>  brcm	Broadcom Corporation
>  cavium	Cavium, Inc.
> 
