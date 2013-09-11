Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024Ab3IKU6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 16:58:17 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47439 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939Ab3IKU6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 16:58:16 -0400
Date: Wed, 11 Sep 2013 16:58:14 -0400 (EDT)
Message-Id: <20130911.165814.2091435893983550695.davem@davemloft.net>
To: cmetcalf@tilera.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: tilegx driver: avoid compiler warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <201309091822.r89IMXmA032018@farm-0002.internal.tilera.com>
References: <201309091822.r89IMXmA032018@farm-0002.internal.tilera.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 11 Sep 2013 13:58:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 9 Sep 2013 14:11:54 -0400

> The "id" variable was being incremented in common code, but only
> initialized and used in IPv4 code.  We move the increment to the IPv4
> code too, and then legitimately use the uninitialized_var() macro to
> avoid the gcc 4.6 warning that 'id' may be used uninitialized.
> Note that gcc 4.7 does not warn.
> 
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>

Ugly situation, but whatever, applied :-)
