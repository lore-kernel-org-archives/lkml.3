Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407Ab3BKGoM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 01:44:12 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:44844 "EHLO
	sivan.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab3BKGoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 01:44:11 -0500
Date: Mon, 11 Feb 2013 08:44:08 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        grant.likely@secretlab.ca
Subject: Re: [BUG] irq_dispose_mapping after irq request failure
Message-ID: <20130211064408.GC18462@sapphire.tkos.co.il>
References: <20130211053100.GB18462@sapphire.tkos.co.il>
 <20130211061949.GA5561@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130211061949.GA5561@concordia>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Mon, Feb 11, 2013 at 05:19:49PM +1100, Michael Ellerman wrote:
> On Mon, Feb 11, 2013 at 07:31:00AM +0200, Baruch Siach wrote:

[...]

> > mpc85xx_pci_err_probe: Unable to requiest irq 16 for MPC85xx PCI err
> While you're there, can you fix the typo :)

The patch fixing it is already queued at 
http://git.kernel.org/?p=linux/kernel/git/bp/bp.git;a=commitdiff;h=e7d2c215e56dc9fa0a01e26f2acfc3d73c889ba3.

Thanks for your details explanation. I'll now try to figure out what's wrong 
with my device tree.

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
