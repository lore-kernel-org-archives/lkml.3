Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbaGUFwG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 01:52:06 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:61771 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbaGUFwE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 01:52:04 -0400
Date: Mon, 21 Jul 2014 07:51:44 +0200
From: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Benoit Cousson <bcousson@baylibre.com>,
        Shubhrajyoti D <shubhrajyoti@ti.com>, Charulatha V <charu@ti.com>
Subject: Re: [PATCH] spi: omap2-mcspi: fix blatant abuse of the resource
 subsystem
Message-ID: <20140721075144.251bb67d@ipc1.ka-ro>
In-Reply-To: <20140718171035.GQ17528@sirena.org.uk>
References: <1405683053-14104-1-git-send-email-LW@KARO-electronics.de>
	<20140718171035.GQ17528@sirena.org.uk>
Organization: Ka-Ro electronics GmbH
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Mark Brown wrote:
> On Fri, Jul 18, 2014 at 01:30:53PM +0200, Lothar Waßmann wrote:
> > Aua. This really hurts. I wonder how this could ever be admitted to
> > the Linux kernel...
> > Further comments suppressed because the would most likely violate the
> > CDA.
> > 
> > If someone should not grasp what this patch does, they should consider
> > what happens upon unloading/reloading the kernel module.
> > 
> > Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
> 
> I'm not going to apply this with a commit message such as the above.
> Quite aside from the tone the fact that it doesn't describe the issue
> is not helpful for review, one of the things done in review is to try to
> check that the change has the intended effect.
>
Maybe the original author or the maintainer who accepted this can come
up with a decent fix for this.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
