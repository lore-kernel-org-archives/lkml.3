Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933339Ab3CVOV1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 10:21:27 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49821 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116Ab3CVOVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 10:21:25 -0400
Date: Fri, 22 Mar 2013 10:21:23 -0400 (EDT)
Message-Id: <20130322.102123.171722271202170551.davem@davemloft.net>
To: pebolle@tiscali.nl
Cc: acme@ghostprotocols.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] appletalk: remove "config IPDDP_DECAP"
From: David Miller <davem@davemloft.net>
In-Reply-To: <1363908924.1390.164.camel@x61.thuisdomein>
References: <1363908924.1390.164.camel@x61.thuisdomein>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Fri, 22 Mar 2013 07:21:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Bolle <pebolle@tiscali.nl>
Date: Fri, 22 Mar 2013 00:35:24 +0100

> The Kconfig symbol IPDDP_DECAP got added in v2.1.75. It has never been
> used. Its entry can safely be removed.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Applied, thanks.
