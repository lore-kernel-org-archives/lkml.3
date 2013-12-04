Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242Ab3LDMSy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 07:18:54 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:44891 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755406Ab3LDMSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 07:18:53 -0500
Date: Wed, 4 Dec 2013 12:18:49 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: "dt.tangr@gmail.com" <dt.tangr@gmail.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 1/2] usb: chipidea: fix mistake in device tree binding
 of nspire-usb to use vendor name 'lsi' instead of SoC name 'zevio'
Message-ID: <20131204121849.GM16025@e106331-lin.cambridge.arm.com>
References: <1386148808-15065-1-git-send-email-dt.tangr@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386148808-15065-1-git-send-email-dt.tangr@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 09:20:07AM +0000, dt.tangr@gmail.com wrote:
> From: Daniel Tang <dt.tangr@gmail.com>
> 
> The SoC name was mistakenly used instead of the vendor name in the
> device tree binding for nspire-usb.
> 
> This patch fixes this before the driver becomes widely adopted.

How widely adopted is it so far?

I can't see the binding in mainline yet.

> 
> Signed-off-by: Daniel Tang <dt.tangr@gmail.com>
> ---
>  Documentation/devicetree/bindings/usb/ci-hdrc-nspire.txt |    4 ++--
>  drivers/usb/chipidea/ci_hdrc_nspire.c                    |    2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/usb/ci-hdrc-nspire.txt b/Documentation/devicetree/bindings/usb/ci-hdrc-nspire.txt
> index 5ba8e90..ef1fcbf 100644
> --- a/Documentation/devicetree/bindings/usb/ci-hdrc-nspire.txt
> +++ b/Documentation/devicetree/bindings/usb/ci-hdrc-nspire.txt
> @@ -1,7 +1,7 @@
>  * TI-Nspire USB OTG Controller
>  
>  Required properties:
> -- compatible: Should be "zevio,nspire-usb"
> +- compatible: Should be "lsi,nspire-usb"

Surely this should be lsi,zevio-usb, matching the lsi,zevio-timer
binding?

Thanks,
Mark.
