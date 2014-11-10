Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735AbaKJAPl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 19:15:41 -0500
Received: from forward20.mail.yandex.net ([95.108.253.145]:41505 "EHLO
	forward20.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbaKJAPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 19:15:40 -0500
X-Greylist: delayed 330 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Nov 2014 19:15:39 EST
From: =?koi8-r?B?5dfHxc7JyiDwz8zRy8/X?= <zbr@ioremap.net>
Envelope-From: drustafa@yandex.ru
To: NeilBrown <neilb@suse.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        GTA04 owners <gta04-owner@goldelico.com>
In-Reply-To: <20141108103249.4f86786c@notabene.brown>
References: <20141108103249.4f86786c@notabene.brown>
Subject: Re: [PATCH] w1: support auto-load of w1_bq27000 module.
MIME-Version: 1.0
Message-Id: <18301415578289@web5g.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Mon, 10 Nov 2014 03:11:29 +0300
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

08.11.2014, 02:33, "NeilBrown" <neilb@suse.de>:
> 1/ change request_module call to zero-pad single digit
> šššfamily numbers. šThis appears to be the intention of
> šššthe code, but not what it actually does.
>
> šššThis means that the alias created for W1_FAMILY_SMEM_01
> šššmight actually be useful.
>
> 2/ Define a family name for the BQ27000 battery charge monitor.
> šššUnfortunately this is the same number as W1_FAMILY_SMEM_01
> šššso if both a compiled on a system, one module might need to
> šššbe blacklisted.
>
> 3/ Add a MODULE_ALIAS for the bq27000.
>
> Signed-off-by: NeilBrown <neilb@suse.de>

Looks good to me.
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>

Which tree should this patch use to get into the kernel?
