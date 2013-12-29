Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab3L2Vhx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 16:37:53 -0500
Received: from forward13.mail.yandex.net ([95.108.130.120]:34439 "EHLO
	forward13.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab3L2Vhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 16:37:52 -0500
X-Greylist: delayed 653 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Dec 2013 16:37:52 EST
From: Evgeniy Polyakov <zbr@ioremap.net>
Envelope-From: drustafa@yandex.ru
To: David Fries <david@fries.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Marcin Jurkowski <marcin1j@gmail.com>, Josh Boyer <jwboyer@gmail.com>,
        Sven Geggus <lists@fuchsschwanzdomain.de>, GregKH <greg@kroah.com>
In-Reply-To: <1388299556-12669-1-git-send-email-David@Fries.net>
References: <1388299556-12669-1-git-send-email-David@Fries.net>
Subject: Re: [PATCH 00/14] w1: async netlink, search, fixes, and improvements
MIME-Version: 1.0
Message-Id: <60161388352402@web21j.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Mon, 30 Dec 2013 01:26:42 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

29.12.2013, 10:46, "David Fries" <David@Fries.net>:
> This patch series aims to extend and improve the netlink interface to
> the one wire system. šNetlink is exposed as a socket interface which

I've reviewed all your patches and everything looks good.
Thank you David

Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
