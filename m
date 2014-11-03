Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962AbaKCDbo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 22:31:44 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:35823 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbaKCDbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 22:31:42 -0500
Message-ID: <5456F713.8090503@gmail.com>
Date: Sun, 02 Nov 2014 19:31:31 -0800
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
CC: devicetree@vger.kernel.org, Brian Norris <computersforpeace@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of/irq: Drop obsolete 'interrupts' vs 'interrupts-extended'
 text
References: <20141101233531.4958.96713.stgit@bhelgaas-glaptop2.roam.corp.google.com>
In-Reply-To: <20141101233531.4958.96713.stgit@bhelgaas-glaptop2.roam.corp.google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 01/11/2014 16:35, Bjorn Helgaas a écrit :
> a9ecdc0fdc54 ("of/irq: Fix lookup to use 'interrupts-extended' property
> first") updated the description to say that:
>
>    - Both 'interrupts' and 'interrupts-extended' may be present
>    - Software should prefer 'interrupts-extended'
>    - Software that doesn't comprehend 'interrupts-extended' may use
>      'interrupts'
>
> But there is still a paragraph at the end that prohibits having both and
> says 'interrupts' should be preferred.
>
> Remove the contradictory text.
>
> Fixes: a9ecdc0fdc54 ("of/irq: Fix lookup to use 'interrupts-extended' property first")
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>

> CC: stable@vger.kernel.org	# v3.13+
> ---
>   .../bindings/interrupt-controller/interrupts.txt   |    4 ----
>   1 file changed, 4 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt b/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
> index ce6a1a072028..8a3c40829899 100644
> --- a/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
> +++ b/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
> @@ -30,10 +30,6 @@ should only be used when a device has multiple interrupt parents.
>     Example:
>   	interrupts-extended = <&intc1 5 1>, <&intc2 1 0>;
>
> -A device node may contain either "interrupts" or "interrupts-extended", but not
> -both. If both properties are present, then the operating system should log an
> -error and use only the data in "interrupts".
> -
>   2) Interrupt controller nodes
>   -----------------------------
>
>
