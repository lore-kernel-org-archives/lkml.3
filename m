Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbaCJAaF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 20:30:05 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37270 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615AbaCJAaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 20:30:03 -0400
Date: Sun, 09 Mar 2014 20:30:01 -0400 (EDT)
Message-Id: <20140309.203001.1318893833441564547.davem@davemloft.net>
To: sebastian.hesselbarth@gmail.com
Cc: rob@landley.net, andrew@lunn.ch, f.fainelli@gmail.com,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: Add sysfs attribute to prevent PHY suspend
From: David Miller <davem@davemloft.net>
In-Reply-To: <531CF864.9040406@gmail.com>
References: <1394192092-27461-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<20140309.191235.1047481546773873653.davem@davemloft.net>
	<531CF864.9040406@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 09 Mar 2014 17:30:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Date: Mon, 10 Mar 2014 00:25:24 +0100

> There is no way to determine if a bootloader is broken or not. The
> sysfs knob allows to provide a use case based decision. Of course,
> we can invent some freaky device tree property but that the DT
> maintainers will not like either.

My point is that whatever mechanism is used to "decide" that the sysfs
knob gets set, can also be used to "decide" that a DT property is
instantiated in the device tree.
