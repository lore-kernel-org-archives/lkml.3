Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbaJNUX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 16:23:56 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44414 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840AbaJNUXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 16:23:55 -0400
Date: Tue, 14 Oct 2014 16:23:52 -0400 (EDT)
Message-Id: <20141014.162352.791378690757940770.davem@davemloft.net>
To: linux@roeck-us.net
Cc: f.fainelli@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch
Subject: Re: [PATCH] dsa: mv88e6171: Fix tag_protocol check
From: David Miller <davem@davemloft.net>
In-Reply-To: <1413310864-16830-1-git-send-email-linux@roeck-us.net>
References: <1413310864-16830-1-git-send-email-linux@roeck-us.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 Oct 2014 13:23:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>
Date: Tue, 14 Oct 2014 11:21:04 -0700

> tag_protocol is now an enum, so drivers have to check against it.
> 
> Cc: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Applied, thanks.
