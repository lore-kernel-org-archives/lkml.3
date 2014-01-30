Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbaA3OpV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 09:45:21 -0500
Received: from mail-vb0-f45.google.com ([209.85.212.45]:46635 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbaA3OpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 09:45:18 -0500
MIME-Version: 1.0
In-Reply-To: <1391092168-21246-5-git-send-email-florian.vaussard@epfl.ch>
References: <1391092168-21246-1-git-send-email-florian.vaussard@epfl.ch>
	<1391092168-21246-5-git-send-email-florian.vaussard@epfl.ch>
Date: Thu, 30 Jan 2014 08:45:17 -0600
Message-ID: <CAL_JsqJiQ070Pe1h43KkSY+AEY7mO52-xvBK06PFj+gRji86MA@mail.gmail.com>
Subject: Re: [PATCH 4/5] Documentation: devicetree: sja1000: add reg-io-width binding
From: Rob Herring <robherring2@gmail.com>
To: Florian Vaussard <florian.vaussard@epfl.ch>
Cc: Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 8:29 AM, Florian Vaussard
<florian.vaussard@epfl.ch> wrote:
> Add the reg-io-width property to describe the width of the memory
> accesses.
>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
> Cc: Kumar Gala <galak@codeaurora.org>
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>

Acked-by: Rob Herring <robh@kernel.org>

> ---
>  Documentation/devicetree/bindings/net/can/sja1000.txt | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/net/can/sja1000.txt b/Documentation/devicetree/bindings/net/can/sja1000.txt
> index f2105a4..b4a6d53 100644
> --- a/Documentation/devicetree/bindings/net/can/sja1000.txt
> +++ b/Documentation/devicetree/bindings/net/can/sja1000.txt
> @@ -12,6 +12,10 @@ Required properties:
>
>  Optional properties:
>
> +- reg-io-width : Specify the size (in bytes) of the IO accesses that
> +       should be performed on the device.  Valid value is 1, 2 or 4.
> +       Default to 1 (8 bits).
> +
>  - nxp,external-clock-frequency : Frequency of the external oscillator
>         clock in Hz. Note that the internal clock frequency used by the
>         SJA1000 is half of that value. If not specified, a default value
> --
> 1.8.1.2
>
