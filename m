Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbaCJAlF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 20:41:05 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37334 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbaCJAlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 20:41:03 -0400
Date: Sun, 09 Mar 2014 20:41:01 -0400 (EDT)
Message-Id: <20140309.204101.47552917508273123.davem@davemloft.net>
To: sebastian.hesselbarth@gmail.com
Cc: rob@landley.net, andrew@lunn.ch, f.fainelli@gmail.com,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: Add sysfs attribute to prevent PHY suspend
From: David Miller <davem@davemloft.net>
In-Reply-To: <531D094C.1090205@gmail.com>
References: <531CF864.9040406@gmail.com>
	<20140309.203001.1318893833441564547.davem@davemloft.net>
	<531D094C.1090205@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 09 Mar 2014 17:41:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Date: Mon, 10 Mar 2014 01:37:32 +0100

> The mechanism is manual, no automatic way to determine it.

We recognize BIOS and ACPI bugs and work around them, by looking at
version information and whatnot, so you really can't convince me that
something similar can't be done here perhaps in the platform code.


