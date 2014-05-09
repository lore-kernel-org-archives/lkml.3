Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968AbaEICm4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 22:42:56 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:32828 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbaEICmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 22:42:54 -0400
Date: Thu, 08 May 2014 22:42:52 -0400 (EDT)
Message-Id: <20140508.224252.1337086843732451389.davem@davemloft.net>
To: boris.brezillon@free-electrons.com
Cc: olof@lixom.net, nicolas.ferre@atmel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] netdev: add support for interface name retrieval from
 DT aliases
From: David Miller <davem@davemloft.net>
In-Reply-To: <1399390594-1409-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1399390594-1409-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 08 May 2014 19:42:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris BREZILLON <boris.brezillon@free-electrons.com>
Date: Tue,  6 May 2014 17:36:34 +0200

> There is currently no proper way to bind a net interface to a specific
> name. The interface name is chosen based on the interface type (eth,
> wlan, ...) and the interfaces already registered (the core codes takes
> the first unused interface id of the given type).
> 
> Add support for DT retrieval of the interface id based on DT aliases.
> The alias name must match the interface type (e.g. ethX if you're defining
> an ethernet dev alias).
> 
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>

This really isn't kosher at all.

And there absolutely is a proper way to bind a net interface to
a specific name, udev has provided this facility for years.

I'm not applying this, sorry.
