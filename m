Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab3FGAbf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 20:31:35 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:59233 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab3FGAbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 20:31:34 -0400
Date: Thu, 6 Jun 2013 17:27:12 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Axel Lin <axel.lin@ingics.com>, Rupesh Kumar <rupesh.kumar@stericsson.com>,
        Michel JAOUEN <michel.jaouen@stericsson.com>,
        Loic Pallardy <loic.pallardy@stericsson.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arun Murthy <arun.murthy@linaro.org>
Subject: Re: [PATCH] power_supply: pm2301_charger: Return error if
 create_singlethread_workqueue fails
Message-ID: <20130607002711.GD7052@lizard.sbx05280.losalca.wayport.net>
References: <1368710224.5500.1.camel@phoenix>
 <CACRpkda3BXjuvJvBam1fZMg5v_RBV7m7B0jfXoWYMpU60LL3ag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CACRpkda3BXjuvJvBam1fZMg5v_RBV7m7B0jfXoWYMpU60LL3ag@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 01:42:43PM +0200, Linus Walleij wrote:
> On Thu, May 16, 2013 at 3:17 PM, Axel Lin <axel.lin@ingics.com> wrote:
> 
> > Return error instead of 0 if create_singlethread_workqueue call fails.
> >
> > Signed-off-by: Axel Lin <axel.lin@ingics.com>
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Also applied, thank you!

Anton
