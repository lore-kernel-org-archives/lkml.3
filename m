Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869AbaKJAQf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 19:16:35 -0500
Received: from forward20.mail.yandex.net ([95.108.253.145]:41989 "EHLO
	forward20.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbaKJAQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 19:16:33 -0500
X-Greylist: delayed 383 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Nov 2014 19:16:32 EST
From: =?koi8-r?B?5dfHxc7JyiDwz8zRy8/X?= <zbr@ioremap.net>
Envelope-From: drustafa@yandex.ru
To: NeilBrown <neilb@suse.de>, Tony Lindgren <tony@atomide.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        GTA04 owners <gta04-owner@goldelico.com>
In-Reply-To: <20141108103032.5426db7a@notabene.brown>
References: <20141108103032.5426db7a@notabene.brown>
Subject: Re: [PATCH] w1: omap-hdq: support device probing with device-tree.
MIME-Version: 1.0
Message-Id: <17841415578204@web5g.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Mon, 10 Nov 2014 03:10:04 +0300
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

08.11.2014, 02:30, "NeilBrown" <neilb@suse.de>:
> This driver has no 'compatible' string and so is not found when
> using device-tree.
>
> Add one with value to match
> ššššššššššššššššhdqw1w: 1w@480b2000 {
> device in omap3.dtsi.
>
> Signed-off-by: NeilBrown <neilb@suse.de>

Looks good to me
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
