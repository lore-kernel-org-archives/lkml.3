Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891Ab3CGCz1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 21:55:27 -0500
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:43630
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751639Ab3CGCzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 21:55:25 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI1432I4015Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 7 Mar 2013 10:55:19 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: mxs: cfa10049: Fix fb initialisation function
Message-ID: <20130307025517.GC5369@S2101-09.ap.freescale.net>
References: <1362496415-6986-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1362496415-6986-1-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 04:13:35PM +0100, Maxime Ripard wrote:
> Commit 1fe42740 ("ARM: dts: mxs: Add the LCD to the 10049 board") seem
> to have been applied with some fuzzyness, and the framebuffer
> initialisation code for the CFA-10049 ended up in the CFA-10037
> initialisation function.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Thanks, applied.

Shawn

