Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931Ab3FQXYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 19:24:46 -0400
Received: from vps1.hno.se ([31.192.227.87]:46101 "EHLO vps1.hno.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389Ab3FQXYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 19:24:44 -0400
Message-ID: <1371511415.9185.18.camel@localhost>
Subject: Re: [linux-sunxi] Re: [PATCH 1/2] Initial support for Allwinner's
 Security ID fuses
From: Henrik =?ISO-8859-1?Q?Nordstr=F6m?= <henrik@henriknordstrom.net>
To: linux-sunxi@googlegroups.com
Cc: Oliver Schinagl <oliver+list@schinagl.nl>, arnd@arndb.de,
        maxime.ripard@free-electrons.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, andy.shevchenko@gmail.com,
        linux@arm.linux.org.uk, linus.walleij@linaro.org,
        Oliver Schinagl <oliver@schinagl.nl>
Date: Tue, 18 Jun 2013 01:23:35 +0200
In-Reply-To: <20130617225847.GA9494@kroah.com>
References: <1371502778-15849-1-git-send-email-oliver+list@schinagl.nl>
	 <1371502778-15849-2-git-send-email-oliver+list@schinagl.nl>
	 <20130617225847.GA9494@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mån 2013-06-17 klockan 15:58 -0700 skrev Greg KH:

> Really?  I don't mind it but is this something that is ok to add to the
> pool?  Will it be different on different machines with this device?  Or
> will it always be the same on all systems with this device?

The data is unique per CPU, so it's different on every machine and is
why it was suggested to have it added to the pool.

Regards
Henrik

