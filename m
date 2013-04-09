Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936220Ab3DIWfg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 18:35:36 -0400
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:52816
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751808Ab3DIWfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 18:35:34 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839h944hd24he5bhf0ah1220h1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
Date: Tue, 9 Apr 2013 17:31:58 -0500
From: Kim Phillips <kim.phillips@freescale.com>
To: Vakul Garg <vakul@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Andy Fleming <afleming@freescale.com>,
        Shaveta Leekha <shaveta@freescale.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] powerpc/crypto: Add property for 'era' in SEC dts
 crypto node
Message-ID: <20130409173158.5eb44856b3304a34b6060dbf@freescale.com>
In-Reply-To: <1365508233-26292-1-git-send-email-vakul@freescale.com>
References: <1365508233-26292-1-git-send-email-vakul@freescale.com>
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Apr 2013 17:20:33 +0530
Vakul Garg <vakul@freescale.com> wrote:

> The crypto node now contains a new property 'fsl,sec-era'.
> This is required so that applications can retrieve era info without
> having to be able to read SEC's register space.
> 
> Signed-off-by: Vakul Garg <vakul@freescale.com>
> ---
>  arch/powerpc/boot/dts/fsl/pq3-sec4.4-0.dtsi   |    1 +
>  arch/powerpc/boot/dts/fsl/qoriq-sec4.0-0.dtsi |    1 +
>  arch/powerpc/boot/dts/fsl/qoriq-sec4.2-0.dtsi |    1 +
>  arch/powerpc/boot/dts/fsl/qoriq-sec5.0-0.dtsi |    1 +
>  arch/powerpc/boot/dts/fsl/qoriq-sec5.2-0.dtsi |    1 +
>  arch/powerpc/boot/dts/fsl/qoriq-sec5.3-0.dtsi |    1 +
>  6 files changed, 6 insertions(+), 0 deletions(-)

missing p1023si-post.dtsi and qoriq-sec4.1-0.dtsi files.

Kim

