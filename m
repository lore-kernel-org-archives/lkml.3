Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751229AbaK0SLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 13:11:55 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:23831 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbaK0SLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 13:11:54 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19gBaue6fQoljReEf/jjx1b1OXANdB/thk=
X-DKIM: OpenDKIM Filter v2.0.1 titan 00D7D62597E
Date: Thu, 27 Nov 2014 13:11:43 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Bresticker <abrestic@chromium.org>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>
Subject: Re: linux-next: manual merge of the irqchip tree with the mips tree
Message-ID: <20141127181143.GN22670@titan.lakedaemon.net>
References: <20141127165719.2e5cb4e4@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141127165719.2e5cb4e4@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,

On Thu, Nov 27, 2014 at 04:57:19PM +1100, Stephen Rothwell wrote:
> Hi Jason,
> 
> Today's linux-next merge of the irqchip tree got a conflict in
> drivers/irqchip/Makefile between commit 8a19b8f19429 ("MIPS: Move GIC
> to drivers/irqchip/") from the mips tree and commit 5fe3bba3088c
> ("irqchip: mtk-sysirq: Add sysirq interrupt polarity support") from the
> irqchip tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good, thanks!

thx,

Jason.
