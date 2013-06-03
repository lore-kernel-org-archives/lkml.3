Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759260Ab3FCWnV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:43:21 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:18402
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758621Ab3FCWnP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:43:15 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz17326ah8275bh8275dhz2dh2a8h668h839h944hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h16a6h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1155h)
Date: Mon, 3 Jun 2013 17:43:05 -0500
From: Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH v2 05/15] fsl_pmc: update device bindings
To: Zhao Chenhui <chenhui.zhao@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
References: <1366368468-29143-1-git-send-email-chenhui.zhao@freescale.com>
	<1366368468-29143-5-git-send-email-chenhui.zhao@freescale.com>
In-Reply-To: <1366368468-29143-5-git-send-email-chenhui.zhao@freescale.com>
	(from chenhui.zhao@freescale.com on Fri Apr 19 05:47:38 2013)
X-Mailer: Balsa 2.4.12
Message-ID: <1370299385.21388.10@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2013 05:47:38 AM, Zhao Chenhui wrote:
> From: Li Yang <leoli@freescale.com>
> 
> Signed-off-by: Li Yang <leoli@freescale.com>
> Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
> ---
>  .../devicetree/bindings/powerpc/fsl/pmc.txt        |   59  
> +++++++++++--------
>  1 files changed, 34 insertions(+), 25 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/powerpc/fsl/pmc.txt  
> b/Documentation/devicetree/bindings/powerpc/fsl/pmc.txt
> index 07256b7..f1f749f 100644
> --- a/Documentation/devicetree/bindings/powerpc/fsl/pmc.txt
> +++ b/Documentation/devicetree/bindings/powerpc/fsl/pmc.txt
> @@ -9,15 +9,20 @@ Properties:
> 
>    "fsl,mpc8548-pmc" should be listed for any chip whose PMC is
>    compatible.  "fsl,mpc8536-pmc" should also be listed for any chip
> -  whose PMC is compatible, and implies deep-sleep capability.
> +  whose PMC is compatible, and implies deep-sleep capability and
> +  wake on user defined packet(wakeup on ARP).
> +
> +  "fsl,p1022-pmc" should be listed for any chip whose PMC is
> +  compatible, and implies lossless Ethernet capability during sleep.
> 
>    "fsl,mpc8641d-pmc" should be listed for any chip whose PMC is
>    compatible; all statements below that apply to "fsl,mpc8548-pmc"  
> also
>    apply to "fsl,mpc8641d-pmc".
> 
>    Compatibility does not include bit assignments in  
> SCCR/PMCDR/DEVDISR; these
> -  bit assignments are indicated via the sleep specifier in each  
> device's
> -  sleep property.
> +  bit assignments are indicated via the clock nodes.  Device which  
> has a
> +  controllable clock source should have a "fsl,pmc-handle" property  
> pointing
> +  to the clock node.

Please respond to the feedback given on v1:
http://patchwork.ozlabs.org/patch/147177/

Also indicate, below the ---, what has changed from previous versions.

-Scott
