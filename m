Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894AbbA0IEd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 03:04:33 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:48264 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757278AbbA0IEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 03:04:31 -0500
Date: Tue, 27 Jan 2015 00:04:30 -0800 (PST)
Message-Id: <20150127.000430.1352169065847404927.davem@davemloft.net>
To: vivien.didelot@savoirfairelinux.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@savoirfairelinux.com
Subject: Re: [PATCH] net: dsa/mv88e6xxx: add reg read and write debug
From: David Miller <davem@davemloft.net>
In-Reply-To: <1422047436-6864-1-git-send-email-vivien.didelot@savoirfairelinux.com>
References: <1422047436-6864-1-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 27 Jan 2015 00:04:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Date: Fri, 23 Jan 2015 16:10:36 -0500

> This commit adds debug messages for the generic mv88e6xxx read and write
> routines. The output is similar to this:
> 
>     mdio-gpio mdio-gpio.0: <- addr: 0x1b reg: 0x05 val: 0x4000
>     mdio-gpio mdio-gpio.0: -> addr: 0x1b reg: 0x07 val: 0x3113
>     mdio-gpio mdio-gpio.0: -> addr: 0x1b reg: 0x08 val: 0x0330
>     mdio-gpio mdio-gpio.0: -> addr: 0x1b reg: 0x09 val: 0x0000
> 
> This is convenient to dynamically debug operations through debugfs with:
> 
>     echo file mv88e6xxx.c +p > <debugfs>/dynamic_debug/control
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>

Applied, thanks.
