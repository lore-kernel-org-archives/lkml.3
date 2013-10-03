Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab3JCIJC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 04:09:02 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:33176 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab3JCII5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 04:08:57 -0400
MIME-Version: 1.0
In-Reply-To: <1371799414-3654-1-git-send-email-b.brezillon@overkiz.com>
References: <1371799176-3408-1-git-send-email-b.brezillon@overkiz.com> <1371799414-3654-1-git-send-email-b.brezillon@overkiz.com>
From: Fabio Porcedda <fabio.porcedda@gmail.com>
Date: Thu, 3 Oct 2013 10:08:37 +0200
Message-ID: <CAHkwnC_Q5XVcb5m5gZuG+s7ojgBb6b29pW9_rENA1sBjo4+-7Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] watchdog: at91sam9_wdt: update device tree doc
To: Boris BREZILLON <b.brezillon@overkiz.com>
Cc: Wim Van Sebroeck <wim@iguana.be>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Yang Wenyou <Wenyou.Yang@atmel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        linux-watchdog@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 9:23 AM, Boris BREZILLON
<b.brezillon@overkiz.com> wrote:
> Add new at91sam9 watchdog properties to the documentation.
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> ---
>  .../devicetree/bindings/watchdog/atmel-wdt.txt     |   30 ++++++++++++++++++--
>  1 file changed, 28 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/watchdog/atmel-wdt.txt b/Documentation/devicetree/bindings/watchdog/atmel-wdt.txt
> index fcdd48f..e043106 100644
> --- a/Documentation/devicetree/bindings/watchdog/atmel-wdt.txt
> +++ b/Documentation/devicetree/bindings/watchdog/atmel-wdt.txt
> @@ -9,11 +9,37 @@ Required properties:
>
>  Optional properties:
>  - timeout-sec: contains the watchdog timeout in seconds.

Why are you removing the documentation about this property?

Regards
-- 
Fabio Porcedda
