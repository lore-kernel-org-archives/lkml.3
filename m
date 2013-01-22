Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab3AVS6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 13:58:53 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:55610 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab3AVS6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 13:58:52 -0500
Date: Tue, 22 Jan 2013 13:58:47 -0500 (EST)
Message-Id: <20130122.135847.466818986790360986.davem@davemloft.net>
To: thierry.reding@avionic-design.de
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        dmitry.torokhov@gmail.com, arnd@arndb.de, w.sang@pengutronix.de,
        netdev@vger.kernel.org
Subject: Re: [PATCH 20/33] net: Convert to devm_ioremap_resource()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130122065629.GA14523@avionic-0098.adnet.avionic-design.de>
References: <1358762966-20791-21-git-send-email-thierry.reding@avionic-design.de>
	<20130121.152913.1377695352860141642.davem@davemloft.net>
	<20130122065629.GA14523@avionic-0098.adnet.avionic-design.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <thierry.reding@avionic-design.de>
Date: Tue, 22 Jan 2013 07:56:29 +0100

> I planned to do so initially, but that yielded a Cc list of 156 people
> and mailing lists,

Just use mailing lists, the individuals are subscribed to the subsystem
lists that cover what they maintain.

Yes, CC:'ing 156 "people" is stupid.
