Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab3HASbE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 14:31:04 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51876 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab3HASbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 14:31:03 -0400
Date: Thu, 01 Aug 2013 11:31:00 -0700 (PDT)
Message-Id: <20130801.113100.2059303096028571906.davem@davemloft.net>
To: cmetcalf@tilera.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 13/12] tile: set hw_features and vlan_features in
 setup
From: David Miller <davem@davemloft.net>
In-Reply-To: <201308011545.r71Fjbco017295@farm-0002.internal.tilera.com>
References: <799eca39dc7f85ba12e1d8c5b072f8b6740fda1c.1375283106.git.cmetcalf@tilera.com>
	<20130731.122534.774117327230299927.davem@redhat.com>
	<201308011545.r71Fjbco017295@farm-0002.internal.tilera.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 01 Aug 2013 11:31:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 1 Aug 2013 11:36:42 -0400

> This change allows the user to configure various features of the tile
> networking drivers on and off.  There is no change to the default
> initialization state of either the tilegx or tilepro drivers.
> 
> Neither driver needs the ndo_fix_features or ndo_set_features callbacks,
> since the generic code already handles the dependencies for
> fix_features, and there is no hardware state to tweak in set_features.
> 
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> ---
> David, I've fixed the drivers to use hw_features as a follow-on "13 of
> 12" patch in the v2 series, rather than rebasing the previous patches,
> since they weren't actually buggy as-is, and this was simpler.  However,
> I am happy to provide a v3 of the patch series with the hw_features
> change rebased to the front if that feels better to you.

Please redo your patch series properly rather than appending fixes on
top, thank you.
