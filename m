Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581AbaFEHnQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 03:43:16 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41120 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbaFEHnO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 03:43:14 -0400
Date: Thu, 05 Jun 2014 00:43:11 -0700 (PDT)
Message-Id: <20140605.004311.19890338095820543.davem@davemloft.net>
To: linus.luessing@web.de
Cc: netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        stephen@networkplumber.org, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCHv3 net-next 0/4] bridge: multicast snooping patches /
 exports
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140602184215.GA2460@Linus-Debian>
References: <1401732466-3027-1-git-send-email-linus.luessing@web.de>
	<20140602184215.GA2460@Linus-Debian>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 05 Jun 2014 00:43:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Lüssing <linus.luessing@web.de>
Date: Mon, 2 Jun 2014 20:42:15 +0200

> Changes in v3:
> 
> * use EXPORT_SYMBOL_GPL() instead of EXPORT_SYMBOL()

This is not a sufficient header posting.

You must also describe at a high level what this patch series is
doing, and why you are doing it.
