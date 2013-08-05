Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808Ab3HEWoX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 18:44:23 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50507 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701Ab3HEWoV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 18:44:21 -0400
Date: Mon, 05 Aug 2013 15:44:20 -0700 (PDT)
Message-Id: <20130805.154420.599165201115948715.davem@davemloft.net>
To: linus.luessing@web.de
Cc: bridge@lists.linux-foundation.org, stephen@networkplumber.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        herbert@gondor.hengli.com.au, amwang@redhat.com,
        linux@baker-net.org.uk, pebolle@tiscali.nl
Subject: Re: [PATCH] bridge: don't try to update timers in case of broken
 MLD queries
From: David Miller <davem@davemloft.net>
In-Reply-To: <1375741925-22179-1-git-send-email-linus.luessing@web.de>
References: <1375741925-22179-1-git-send-email-linus.luessing@web.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 05 Aug 2013 15:44:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Lüssing <linus.luessing@web.de>
Date: Tue,  6 Aug 2013 00:32:05 +0200

> Currently we are reading an uninitialized value for the max_delay
> variable when snooping an MLD query message of invalid length and would
> update our timers with that.
> 
> Fixing this by simply ignoring such broken MLD queries (just like we do
> for IGMP already).
> 
> This is a regression introduced by:
> "bridge: disable snooping if there is no querier" (b00589af3b04)
> 
> Reported-by: Paul Bolle <pebolle@tiscali.nl>
> Signed-off-by: Linus Lüssing <linus.luessing@web.de>

Applied, thanks.
