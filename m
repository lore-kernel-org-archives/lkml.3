Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbaIESRv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 14:17:51 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:44636 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750863AbaIESRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 14:17:49 -0400
Date: Fri, 5 Sep 2014 19:17:31 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Mark Brown <broonie@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, nicolas.pitre@linaro.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: linux-next: Tree for Sep 1
Message-ID: <20140905181731.GK30401@n2100.arm.linux.org.uk>
References: <20140901230728.GM29327@sirena.org.uk> <1627064.QhxvejlWdk@amdc1032> <alpine.DEB.2.11.1409020857110.9201@gentwo.org> <alpine.DEB.2.11.1409020958530.9608@gentwo.org> <20140904171123.GD26364@mtj.dyndns.org> <alpine.DEB.2.11.1409041259110.14314@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1409041259110.14314@gentwo.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 12:59:39PM -0500, Christoph Lameter wrote:
> On Fri, 5 Sep 2014, Tejun Heo wrote:
> 
> > I suppose this should go through percpu/for-3.18-consistent-ops?  Can
> > we please cc irq folks and get acks?
> 
> Russell and Nicolas were cced. This is arm specific.

Sorry, but I don't have much to do with ARM IRQ stuff anymore -
everything that gets moved out of arch/arm has responsibility
automatically transferred to someone else without any referral to
me.

Hence, it's up to the genirq/irqchip maintainers now.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
