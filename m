Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbbANVL1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 16:11:27 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:45394 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbbANVLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 16:11:25 -0500
Date: Wed, 14 Jan 2015 16:04:00 -0500 (EST)
Message-Id: <20150114.160400.695160389747729730.davem@davemloft.net>
To: nicolas.ferre@atmel.com
Cc: xander.huff@ni.com, netdev@vger.kernel.org, jaeden.amero@ni.com,
        rich.tollerton@ni.com, ben.shelton@ni.com, brad.mouring@ni.com,
        linux-kernel@vger.kernel.org, cyrille.pitchen@atmel.com
Subject: Re: [PATCH 2/2] net/macb: improved ethtool statistics support
From: David Miller <davem@davemloft.net>
In-Reply-To: <54B690F5.5080308@atmel.com>
References: <1421187351-27279-1-git-send-email-xander.huff@ni.com>
	<1421187351-27279-2-git-send-email-xander.huff@ni.com>
	<54B690F5.5080308@atmel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 14 Jan 2015 13:04:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@atmel.com>
Date: Wed, 14 Jan 2015 16:53:25 +0100

> I see some issues with this patch: can you hold it a little bit please
> (aka NAK)?

I already applied these patches last night to my net-next tree, so
relative fixups against that will need to be submitted.

Submitting new versions of these patches therefore isn't going to
work.
