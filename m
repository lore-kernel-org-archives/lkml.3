Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbaDGOo7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 10:44:59 -0400
Received: from ms-10.1blu.de ([178.254.4.101]:48985 "EHLO ms-10.1blu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754650AbaDGOoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 10:44:55 -0400
Message-ID: <1396881883.12563.0.camel@archlinux-laptop.fritz.box>
Subject: Re: [PATCH] staging: rtl8187se: Fix warning symbol should be static
From: Jonas Hahnfeld <hahnjo@hahnjo.de>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: driverdev-devel@linuxdriverproject.org,
        Josh Triplett <josh@joshtriplett.org>, devel@driverdev.osuosl.org,
        Andreea-Cristina Bernat <bernat.ada@gmail.com>,
        Andrea Merello <andrea.merello@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ana Rey <anarey@gmail.com>, linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Teodora Baluta <teobaluta@gmail.com>,
        Dan LaManna <dan.lamanna@gmail.com>,
        Pablo Neira Ayuso <pablo@gnumonks.org>
Date: Mon, 07 Apr 2014 16:44:43 +0200
In-Reply-To: <201404070134.46030.s.L-H@gmx.de>
References: <1396799183-7412-1-git-send-email-hahnjo@hahnjo.de>
	 <20140406160903.GA8114@leaf> <201404070134.46030.s.L-H@gmx.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Con-Id: 154395
X-Con-U: 0-hahnjo
X-Originating-IP: 79.233.151.28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 07.04.2014, 01:34 +0000 schrieb Stefan Lippers-Hollmann:
> Hi
> 
> On Sunday 06 April 2014, Josh Triplett wrote:
> > On Sun, Apr 06, 2014 at 05:46:04PM +0200, Jonas Hahnfeld wrote:
> > > This patch solves some sparse warnings about "symbol [...] was not
> > > declared. Should it be static?" by including the correct header files.
> > > 
> > > Signed-off-by: Jonas Hahnfeld <hahnjo@hahnjo.de>
> > 
> > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> [...]
> 
> Given that that rtl8187se support has already been merged mainline (for
> 3.15-rc1) into the existing rtl8180 (soon to be renamed to rtl818x) 
> driver, wouldn't it make more sense to remove 
> drivers/staging/rtl8187se/ rather than trying to fixing it?
> 
> commit 1eba648f998ef9c31b8cf062754a4a7b4ab9001f
> Author: Andrea Merello <andrea.merello@gmail.com>
> Date:   Wed Mar 26 21:04:23 2014 +0100
> 
>     rtl8180: enable rtl8187se support
>     
>     Finally make rtl8187se works (hopefylly).
>     This patch adds PCI ID for rtl8187, updates copyright notes and
>     updates MODULE_DESCRIPTION.
>     
>     Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>
> 
> Regards
> 	Stefan Lippers-Hollmann

Yes, probably. Sorry, didn't know that, hadn't looked after this!

