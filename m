Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762055Ab3DBSXt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 14:23:49 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:52624 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758373Ab3DBSXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 14:23:48 -0400
X-Greylist: delayed 2142 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Apr 2013 14:23:47 EDT
Date: Tue, 2 Apr 2013 11:23:44 -0700
From: Olof Johansson <olof@lixom.net>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: irq: Call irqchit_init if no init_irq function
 is specified
Message-ID: <20130402182344.GK25867@quad.lixom.net>
References: <1364503606-10597-1-git-send-email-maxime.ripard@free-electrons.com>
 <1364503606-10597-2-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364503606-10597-2-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 09:46:44PM +0100, Maxime Ripard wrote:
> More and more sub-architectures are using only the irqchip_init
> function. Make the core code call this function if no init_irq field is
> provided in the machine description to remove some boilerplate code.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Applied to next/cleanup (fixed the typo in the subject though :).

I'm trying to figure out how to best apply 2/2 without causing a lot of
merge conflicts. It might make sense to either do it late in the merge
window or stage it at the base of 3.11 cleanup. I'll revisit after I've
dealt with the rest of the pull request queue.


-Olof
