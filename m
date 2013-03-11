Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749Ab3CKNhJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 09:37:09 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:37108 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751105Ab3CKNhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 09:37:08 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI1432I1447Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 11 Mar 2013 21:37:23 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Paul Bolle <pebolle@tiscali.nl>
CC: Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: imx: fix typo "DEBUG_IMX50_IMX53_UART"
Message-ID: <20130311133720.GB25910@S2101-09.ap.freescale.net>
References: <1363007760.3137.69.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1363007760.3137.69.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,

On Mon, Mar 11, 2013 at 02:16:00PM +0100, Paul Bolle wrote:
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) Tested by grepping the tree.
> 
> 1) Typo was added in commit f8c95fe6d9adad72fc7bce90f4ab68d119f50c5b
> ("ARM: imx: support DEBUG_LL uart port selection for all i.MX SoCs").
> Looking at that patch and at the tree makes clear that DEBUG_IMX53_UART
> was intended here.

Thanks for the fixing.  Above comment should really be in the commit
log.  I just applied the patch as below.

Shawn

commit 0c52db7e681678f9b2a3fb96c3dd557168b4e025
Author: Paul Bolle <pebolle@tiscali.nl>
Date:   Mon Mar 11 14:16:00 2013 +0100

ARM: imx: fix typo "DEBUG_IMX50_IMX53_UART"

Commit f8c95fe (ARM: imx: support DEBUG_LL uart port selection for all
i.MX SoCs) had a typo that DEBUG_IMX50_IMX53_UART should be
DEBUG_IMX53_UART.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>


