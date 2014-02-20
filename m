Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbaBTDE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 22:04:57 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:46620 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbaBTDE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 22:04:56 -0500
Date: Thu, 20 Feb 2014 03:04:55 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Nishanth Menon <nm@ti.com>
cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tero Kristo <t-kristo@ti.com>
Subject: Re: [PATCH] ARM: OMAP3+: DPLL: stop reparenting to same parent if
 already done
In-Reply-To: <1391591048-19433-1-git-send-email-nm@ti.com>
Message-ID: <alpine.DEB.2.02.1402200304150.25798@utopia.booyaka.com>
References: <1391591048-19433-1-git-send-email-nm@ti.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Feb 2014, Nishanth Menon wrote:

> omap3_noncore_dpll_set_rate forces a reparent to the same clk_ref
> for every call that takes place. This is an can be done only if a change
> is detected.
> 
> Signed-off-by: Nishanth Menon <nm@ti.com>

Queued for v3.15 with Tero's ack unless the patch is updated to indicate 
that it's more than an optimization.


- Paul
