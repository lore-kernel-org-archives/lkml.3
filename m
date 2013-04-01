Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294Ab3DACQb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 22:16:31 -0400
Received: from mail-db8lp0188.outbound.messaging.microsoft.com ([213.199.154.188]:40111
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755688Ab3DACQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 22:16:30 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 1 Apr 2013 10:16:39 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pinctrl: pinctrl-mxs: document the missing pull-ups
Message-ID: <20130401021637.GA1693@S2101-09.ap.freescale.net>
References: <1364601072-30226-1-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1364601072-30226-1-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 30, 2013 at 12:51:12AM +0100, Alexandre Belloni wrote:
> Some pins on the i.mx23 and i.mx28 are missing pull-ups, document that
> oddity because it was difficult to know the expected behaviour.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Applied, thanks.

> ---
> 
> I don't think it is necessary to list the pins with the missing pull ups in
> that file but we may want to explicitly direct to the datasheet as even with
> the same chip, it can depend on the package (BGA or QFP for example).
> 
>  Documentation/devicetree/bindings/pinctrl/fsl,mxs-pinctrl.txt |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/pinctrl/fsl,mxs-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/fsl,mxs-pinctrl.txt
> index f7e8e8f..3077370 100644
> --- a/Documentation/devicetree/bindings/pinctrl/fsl,mxs-pinctrl.txt
> +++ b/Documentation/devicetree/bindings/pinctrl/fsl,mxs-pinctrl.txt
> @@ -70,6 +70,10 @@ Optional subnode-properties:
>      0: Disable the internal pull-up
>      1: Enable the internal pull-up
>  
> +Note that when enabling the pull-up, the internal pad keeper gets disabled.
> +Also, some pins doesn't have a pull up, in that case, setting the fsl,pull-up
> +will only disable the internal pad keeper.
> +
>  Examples:
>  
>  pinctrl@80018000 {
> -- 
> 1.7.10.4
> 

