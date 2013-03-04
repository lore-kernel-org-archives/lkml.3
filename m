Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab3CDC0Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 21:26:16 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:47181 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872Ab3CDC0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 21:26:15 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpio: stmpe: pass DT node to irqdomain
To: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org
Cc: Anmar Oueja <anmar.oueja@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@stericsson.com>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
In-Reply-To: <20130302092309.692CD3E17F8@localhost>
References: <1362139302-23048-1-git-send-email-linus.walleij@stericsson.com> <20130302092309.692CD3E17F8@localhost>
Date: Mon, 04 Mar 2013 10:23:54 +0800
Message-Id: <20130304022354.4540F3E14C0@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 02 Mar 2013 09:23:09 +0000, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Fri, 1 Mar 2013 13:01:42 +0100, Linus Walleij <linus.walleij@stericsson.com> wrote:
> > From: Gabriel Fernandez <gabriel.fernandez@stericsson.com>
> > 
> > The irq domain was implemented but the device tree
> > node was not transmitted to irq_domain_add_simple().
> > 
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Gabriel Fernandez <gabriel.fernandez@stericsson.com>
> > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> 
> Applied, thanks.
> 
> I've got a small branch of fixes that I need to send to Linus for v3.9,
> and then I'll leave the rest of the bug fixes to you.

This patch breaks for CONFIG_OF=n. I've dropped it and it will need to be reposted.

g.
