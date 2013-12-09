Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761264Ab3LIP1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 10:27:21 -0500
Received: from plane.gmane.org ([80.91.229.3]:45554 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124Ab3LIP1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 10:27:20 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Subject: Re: [PATCH 7/9] ARM: dts: pxa27x: skip static platform devices
Date: Mon, 9 Dec 2013 15:26:53 +0000 (UTC)
Message-ID: <l84nft$140$1@ger.gmane.org>
References: <1386348542-9584-1-git-send-email-ynvich@gmail.com>
	<1386543229-1542-1-git-send-email-ynvich@gmail.com>
	<1386543229-1542-8-git-send-email-ynvich@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: ppp89-110-7-80.pppoe.avangarddsl.ru
User-Agent: Pan/0.139 (Sexual Chocolate; GIT bf56508
 git://git.gnome.org/pan2)
Cc: linux-arm-kernel@lists.infradead.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, 09 Dec 2013 02:53:47 +0400, Sergei Ianovich wrote:

> Static plaform devices are created from postcore_initcall(). The status
> quo remains for non-device tree machines.
> 
> Device tree machine now have a chance to prevent spawning of static
> devices by calling pxa27x_skip_init().
> 
> Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
> CC: Russell King - ARM Linux <linux@arm.linux.org.uk>
> CC: Daniel Mack <zonque@gmail.com>
> CC: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/arm/mach-pxa/include/mach/pxa27x.h |  1 +
>  arch/arm/mach-pxa/pxa27x.c              | 10 ++++++++++ 2 files
>  changed, 11 insertions(+)

I would suggest to copy the corresponding code from pxa3xx.c - use 
of_have_populated_dt() instead of adding extra static variable.

-- 
With best wishes
Dmitry


