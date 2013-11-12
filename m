Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402Ab3KLV61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 16:58:27 -0500
Received: from mail-db9lp0249.outbound.messaging.microsoft.com ([213.199.154.249]:4672
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756329Ab3KLV6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 16:58:14 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI936eI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h1155h)
Message-ID: <1384293487.1403.67.camel@snotra.buserror.net>
Subject: Re: [PATCH 1/4] phylib: Add Clause 45 read/write functions
From: Scott Wood <scottwood@freescale.com>
To: <shh.xie@gmail.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <Shruti@freescale.com>, Shaohui Xie <Shaohui.Xie@freescale.com>,
        <madalin.bucur@freescale.com>
Date: Tue, 12 Nov 2013 15:58:07 -0600
In-Reply-To: <1384167864-2457-1-git-send-email-shh.xie@gmail.com>
References: <1384167864-2457-1-git-send-email-shh.xie@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-11-11 at 19:04 +0800, shh.xie@gmail.com wrote:
> From: Andy Fleming
> 
> You need an extra parameter to read or write Clause 45 PHYs, so
> we need a different API with the extra parameter.
> 
> Signed-off-by: Andy Fleming
> Signed-off-by: Shaohui Xie <Shaohui.Xie@freescale.com>

Why did you remove Andy's e-mail address?  Even though it's no longer
valid, it helps identify which specific person you're talking about.

-Scott



