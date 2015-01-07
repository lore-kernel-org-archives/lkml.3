Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbbAGRUT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:20:19 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:19842 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595AbbAGRUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:20:17 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19Cvo+0hTKwPUkKA+nueI1e
Date: Wed, 7 Jan 2015 09:16:26 -0800
From: Tony Lindgren <tony@atomide.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        Paul Walmsley <paul@pwsan.com>, Russell King <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch: arm: mach-omap2: omap_hwmod.c:  Remove some unused
 functions
Message-ID: <20150107171626.GA13010@atomide.com>
References: <1417973047-12972-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417973047-12972-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> [141207 09:23]:
> Removes some functions that are not used anywhere:
> omap_hwmod_pad_route_irq() omap_hwmod_no_setup_reset()
> omap_hwmod_read_hardreset() omap_hwmod_del_initiator_dep()
> omap_hwmod_enable_clocks() omap_hwmod_reset() omap_hwmod_ocp_barrier()
> omap_hwmod_disable_clocks() omap_hwmod_add_initiator_dep()
> 
> This was partially found by using a static code analysis program called cppcheck.

Nice, we should probably run cppcheck for unused functions on
regular basis as we're slowly removing the legacy booting
support in favor of device tree based booting.

Paul, I'm applying all your arch/arm/*omap*/ cppcheck patches
into omap-for-v3.20/cleanup branch that can then be used as a
base for other branches in case of conflicts.

Richard, I've also unified the subject lines to start with
ARM: OMAP2+: and so on to make my pull requests will look
a bit nicer.

Regards,

Tony
