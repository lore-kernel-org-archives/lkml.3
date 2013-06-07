Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab3FGFvc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 01:51:32 -0400
Received: from mail-db8lp0187.outbound.messaging.microsoft.com ([213.199.154.187]:52686
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750789Ab3FGFvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 01:51:31 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(z551biz98dIzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzzz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Fri, 7 Jun 2013 13:51:31 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Mike Turquette <mturquette@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH RFC 0/3] clk: dt: bindings for mux & divider clocks
Message-ID: <20130607055128.GA20780@S2101-09.ap.freescale.net>
References: <1370281990-15090-1-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1370281990-15090-1-git-send-email-mturquette@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike,

On Mon, Jun 03, 2013 at 10:53:07AM -0700, Mike Turquette wrote:
> I am using this code while converting the OMAP4 clock data over to DT

I see these basic clk bindings can be useful for platforms that have
a relatively simple clock tree, but I'm a little surprised that you plan
to move OMAP4 to it.  I'm wondering how many nodes you will have to add
to OMAP4 device tree.  For imx6q example, it means ~200 nodes addition
to device tree, which is obviously a bloating of device tree.

Shawn

> and some common boilerplate code can be factored out of several clock
> drivers if this is merged.

