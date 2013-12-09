Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760957Ab3LIJh6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 04:37:58 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:34219 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab3LIJhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 04:37:54 -0500
Date: Mon, 9 Dec 2013 09:37:48 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, sameo@linux.intel.com,
        Tony Lindgren <tony@atomide.com>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 01/15] mfd: menelaus: Drop __exit section annotation
Message-ID: <20131209093748.GA12675@lee--X1>
References: <1386042188-12246-1-git-send-email-balbi@ti.com>
 <20131203095136.GF11828@lee--X1>
 <20131208190739.GA18977@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131208190739.GA18977@saruman.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The code looks mostly fine, but the implementation of the commit logs
> > seems lazy. Please submit a v3 using coherent sentences with full
> > explanations and correct punctuation.
> 
> example ?

All of your commit messages.

> that macro just helps removing some extra

  ^- Sentences start with an uppercase character.

> line of code and hides ffs() calls.
> 
> while at that, also fix a variable shadowing

  ^- Sentences start with an uppercase character.

> bug where 'int irq' was being redeclared inside
> inner loop while it was also argument to interrupt
> handler.

  < ---------------   50 chars   ----------------- >

Please use the full 72 char (or there abouts) width of the buffer.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
