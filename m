Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056AbaLJQtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 11:49:25 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:16230 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754895AbaLJQtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 11:49:23 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX195elV0nLEPoBy9+uX5Vh4Q
Date: Wed, 10 Dec 2014 08:47:35 -0800
From: Tony Lindgren <tony@atomide.com>
To: Nishanth Menon <nm@ti.com>
Cc: Ravikumar Kattekola <rk@ti.com>,
        =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 0/2] ARM: dts: dra7-evm: Regulator max voltage fixes
Message-ID: <20141210164734.GE30437@atomide.com>
References: <1417608237-12258-1-git-send-email-rk@ti.com>
 <547F0A57.7040806@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547F0A57.7040806@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nishanth Menon <nm@ti.com> [141203 05:06]:
> On 12/03/2014 06:03 AM, Ravikumar Kattekola wrote:
> > Hi,
> > 
> > This set does a minor fix and an update:
> > 
> >    - Fix a typo in the max voltage property of smps6 (vdd_gpu) regulator node added by
> >      the patch : c56a831ca47e ("ARM: dts: DRA7: Add TPS659038 PMIC nodes")
> > 
> >    - Update max voltage property of smps7 (vdd_core) regulator node to align with the 
> >      latest Data Manual
> > 
> > Regards,
> > RK
> > 
> > Ravikumar Kattekola (2):
> >   ARM: dts: dra7-evm: Fix typo in SMPS6 (VDD_GPU) max voltage
> >   ARM: dts: dra7-evm: Update SMPS7 (VDD_CORE) max voltage to match DM
> > 
> >  arch/arm/boot/dts/dra7-evm.dts  |    4 ++--
> >  arch/arm/boot/dts/dra72-evm.dts |    2 +-
> >  2 files changed, 3 insertions(+), 3 deletions(-)
> > 
> These apply to
> 
> https://git.kernel.org/cgit/linux/kernel/git/tmlind/linux-omap.git/log/?h=omap-for-v3.19/dt-v2
> 
> Acked-by: Nishanth Menon <nm@ti.com>

Applying both into omap-for-v3.19/fixes thanks.

Tony
