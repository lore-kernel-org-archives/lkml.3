Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbaKCDt6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 22:49:58 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:42352 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbaKCDtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 22:49:55 -0500
Date: Sun, 02 Nov 2014 22:49:50 -0500 (EST)
Message-Id: <20141102.224950.412405645526169555.davem@davemloft.net>
To: roguelazer@roguelazer.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv4: fix comment in net/ipv4/tcp_input.c to reference
 the correct RFC
From: David Miller <davem@davemloft.net>
In-Reply-To: <1414984260-26020-1-git-send-email-roguelazer@roguelazer.com>
References: <1414984260-26020-1-git-send-email-roguelazer@roguelazer.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 02 Nov 2014 19:49:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Brown <roguelazer@roguelazer.com>
Date: Sun,  2 Nov 2014 19:11:00 -0800

> RFC 5691 has to do with MPEG surround-sound; RFC 5961 has to do
> with hardening TCP against in-window spoofing attacks
> 
> Signed-off-by: James Brown <roguelazer@roguelazer.com>

Already fixed in net-next, thanks.
