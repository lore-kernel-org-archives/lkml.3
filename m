Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757776AbaAJS14 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 13:27:56 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:28149 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaAJS1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 13:27:55 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/5tmqicavx1KvFgDdzCXgGH/d0b13MzPc=
X-DKIM: OpenDKIM Filter v2.0.1 titan D4355506977
Date: Fri, 10 Jan 2014 13:27:44 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] irqchip: mvebu: fixes for v3.13
Message-ID: <20140110182744.GL19878@titan.lakedaemon.net>
References: <20131217145518.GK2609@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131217145518.GK2609@titan.lakedaemon.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

On Tue, Dec 17, 2013 at 09:55:18AM -0500, Jason Cooper wrote:
> Thomas,
> 
> Here's a couple of small fixes for the armada-370-xp driver.  These have
> been in -next for 3 days now.
> 
> thx,
> 
> Jason.
> 
> 
> The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:
> 
>   Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)
> 
> are available in the git repository at:
> 
>   git://git.infradead.org/linux-mvebu.git tags/mvebu-irqchip-fixes-3.13
> 
> for you to fetch changes up to c7f7bd4a136e4b02dd2a66bf95aec545bd93e8db:
> 
>   irqchip: armada-370-xp: fix MSI race condition (2013-12-13 16:34:40 +0000)
> 
> ----------------------------------------------------------------
> mvebu irqchip fixes for v3.13
> 
>  - armada-370-xp
>     - fix races is MSI and IPI
> 
> ----------------------------------------------------------------
> Lior Amsalem (2):
>       irqchip: armada-370-xp: fix IPI race condition
>       irqchip: armada-370-xp: fix MSI race condition
> 
>  drivers/irqchip/irq-armada-370-xp.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

It doesn't seem as though this has been pulled.  Did it fall through the
cracks?

thx,

Jason.
