Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761660Ab3IDCRN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 22:17:13 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53831 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079Ab3IDCRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 22:17:12 -0400
Date: Tue, 03 Sep 2013 22:17:10 -0400 (EDT)
Message-Id: <20130903.221710.1608165855708248750.davem@davemloft.net>
To: pholasek@redhat.com
Cc: hannes@stressinduktion.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv6: ipv6_create_tempaddr cleanup
From: David Miller <davem@davemloft.net>
In-Reply-To: <1377874958-2426-1-git-send-email-pholasek@redhat.com>
References: <1377874958-2426-1-git-send-email-pholasek@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 03 Sep 2013 19:17:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Petr Holasek <pholasek@redhat.com>
Date: Fri, 30 Aug 2013 17:02:38 +0200

> This two-liner removes max_addresses variable which is now unecessary related
> to patch [ipv6: remove max_addresses check from ipv6_create_tempaddr].
> 
> Signed-off-by: Petr Holasek <pholasek@redhat.com>

Applied, thanks.
