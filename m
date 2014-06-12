Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706AbaFLSAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 14:00:45 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53358 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaFLSAn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 14:00:43 -0400
Date: Thu, 12 Jun 2014 11:00:42 -0700 (PDT)
Message-Id: <20140612.110042.301380151424639820.davem@davemloft.net>
To: linus.luessing@web.de
Cc: netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        stephen@networkplumber.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2 net-next] bridge: fix bugs introduced by last
 multicast patchset
From: David Miller <davem@davemloft.net>
In-Reply-To: <1402530084-15061-1-git-send-email-linus.luessing@web.de>
References: <1402530084-15061-1-git-send-email-linus.luessing@web.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 12 Jun 2014 11:00:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Lüssing <linus.luessing@web.de>
Date: Thu, 12 Jun 2014 01:41:22 +0200

> Once my last patchset got applied, I got slapped by an automatic smatch
> and build bot. Here are two patches fixing the according issues, a potential
> null pointer dereference and a compile error when compiling without IPv6.

Series applied, thanks.
