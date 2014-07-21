Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177AbaGUMlO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 08:41:14 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:51596 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141AbaGUMlN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 08:41:13 -0400
Date: Mon, 21 Jul 2014 14:41:04 +0200
From: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Benoit Cousson <bcousson@baylibre.com>, Charulatha V <charu@ti.com>
Subject: Re: [PATCH] spi: omap2-mcspi: fix blatant abuse of the resource
 subsystem
Message-ID: <20140721144104.5e37f1a0@ipc1.ka-ro>
In-Reply-To: <20140721121820.GW17528@sirena.org.uk>
References: <1405683053-14104-1-git-send-email-LW@KARO-electronics.de>
	<20140718171035.GQ17528@sirena.org.uk>
	<20140721075144.251bb67d@ipc1.ka-ro>
	<20140721121820.GW17528@sirena.org.uk>
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
> On Mon, Jul 21, 2014 at 07:51:44AM +0200, Lothar Waßmann wrote:
> > Mark Brown wrote:
> 
> > > I'm not going to apply this with a commit message such as the above.
> > > Quite aside from the tone the fact that it doesn't describe the issue
> > > is not helpful for review, one of the things done in review is to try to
> > > check that the change has the intended effect.
> 
> > Maybe the original author or the maintainer who accepted this can come
> > up with a decent fix for this.
> 
> Just to be clear the issue is with the presentation of your change, it
> is not appropriate to provide a changelog which consists mainly of
> widely directed personal insults especially given that it omits basic
> technical content.
>
I understood that, but I feel incapable to come up with a reasonable
changelog for this.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
