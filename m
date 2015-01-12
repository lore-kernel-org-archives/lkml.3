Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbbALUfM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 15:35:12 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:53494 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438AbbALUfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 15:35:10 -0500
Date: Mon, 12 Jan 2015 15:32:11 -0500 (EST)
Message-Id: <20150112.153211.1568185988607410812.davem@davemloft.net>
To: me@mortis.eu
Cc: linux-kernel@vger.kernel.org, dsterba@suse.cz, mac@melware.de,
        isdn@linux-pingi.de, netdev@vger.kernel.org
Subject: Re: [PATCH RESEND] isdn: fix NUL (\0 or \x00) specification in
 string
From: David Miller <davem@davemloft.net>
In-Reply-To: <1420657812-19445-1-git-send-email-me@mortis.eu>
References: <1420394722-20197-1-git-send-email-me@mortis.eu>
	<1420657812-19445-1-git-send-email-me@mortis.eu>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 12 Jan 2015 12:35:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Giel van Schijndel <me@mortis.eu>
Date: Wed,  7 Jan 2015 20:10:12 +0100

> In C one can either use '\0' or '\x00' (or '\000') to add a NUL byte to
> a string. '\0x00' isn't part of these and will in fact result in a
> single NUL followed by "x00". This fixes that.
> 
> Signed-off-by: Giel van Schijndel <me@mortis.eu>
> Reported-at: http://www.viva64.com/en/b/0299/

Applied, thank you.
