Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab3F0Gbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 02:31:42 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:42664 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab3F0Gbl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 02:31:41 -0400
MIME-Version: 1.0
In-Reply-To: <201306262005.05765.heiko@sntech.de>
References: <201306262003.13256.heiko@sntech.de>
	<201306262005.05765.heiko@sntech.de>
Date: Thu, 27 Jun 2013 12:01:40 +0530
Message-ID: <CAK9yfHzY5uPLmGVjHYGPbqR3_YKdMXCwkcOgowURRdf+8uPwtg@mail.gmail.com>
Subject: Re: [PATCH 3/3] watchdog: dw_wdt: add a devicetree binding
From: Sachin Kamat <sachin.kamat@linaro.org>
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: Wim Van Sebroeck <wim@iguana.be>, Jamie Iles <jamie@jamieiles.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 June 2013 23:35, Heiko Stübner <heiko@sntech.de> wrote:
> The dw_wdt does not use any platform-specific data, so no new properties
> need to be introduced. The dw-apb-wdt naming follows other designware
> components in the kernel and is also written like this in documentation
> describing the component.
>
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> ---
>  .../devicetree/bindings/watchdog/snps-dw-apb-wdt.txt |   18 ++++++++++++++++++
>  drivers/watchdog/dw_wdt.c                            |   10 ++++++++++
>  2 files changed, 28 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/watchdog/snps-dw-apb-wdt.txt
>
> diff --git a/Documentation/devicetree/bindings/watchdog/snps-dw-apb-wdt.txt b/Documentation/devicetree/bindings/watchdog/snps-dw-apb-wdt.txt
> new file mode 100644
> index 0000000..c20cdd1
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/watchdog/snps-dw-apb-wdt.txt
> @@ -0,0 +1,18 @@
> +* Synosis DesignWare APB Watchdog

Probably should be Synopsis?


-- 
With warm regards,
Sachin
