Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbaKRSFh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 13:05:37 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:36048 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263AbaKRSFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 13:05:35 -0500
MIME-Version: 1.0
In-Reply-To: <20141101233531.4958.96713.stgit@bhelgaas-glaptop2.roam.corp.google.com>
References: <20141101233531.4958.96713.stgit@bhelgaas-glaptop2.roam.corp.google.com>
From: Rob Herring <robherring2@gmail.com>
Date: Tue, 18 Nov 2014 12:05:14 -0600
Message-ID: <CAL_JsqK3DU8D9jyCvUMkpXEUTPNb2HMH2uuj3EgSNbYWa6ECPA@mail.gmail.com>
Subject: Re: [PATCH] of/irq: Drop obsolete 'interrupts' vs 'interrupts-extended'
 text
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 1, 2014 at 6:35 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> a9ecdc0fdc54 ("of/irq: Fix lookup to use 'interrupts-extended' property
> first") updated the description to say that:
>
>   - Both 'interrupts' and 'interrupts-extended' may be present
>   - Software should prefer 'interrupts-extended'
>   - Software that doesn't comprehend 'interrupts-extended' may use
>     'interrupts'
>
> But there is still a paragraph at the end that prohibits having both and
> says 'interrupts' should be preferred.
>
> Remove the contradictory text.
>
> Fixes: a9ecdc0fdc54 ("of/irq: Fix lookup to use 'interrupts-extended' property first")
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> CC: stable@vger.kernel.org      # v3.13+

Applied, thanks.

Rob

> ---
>  .../bindings/interrupt-controller/interrupts.txt   |    4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt b/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
> index ce6a1a072028..8a3c40829899 100644
> --- a/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
> +++ b/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
> @@ -30,10 +30,6 @@ should only be used when a device has multiple interrupt parents.
>    Example:
>         interrupts-extended = <&intc1 5 1>, <&intc2 1 0>;
>
> -A device node may contain either "interrupts" or "interrupts-extended", but not
> -both. If both properties are present, then the operating system should log an
> -error and use only the data in "interrupts".
> -
>  2) Interrupt controller nodes
>  -----------------------------
>
>
