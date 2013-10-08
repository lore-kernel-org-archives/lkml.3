Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab3JHUwo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 16:52:44 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55283 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401Ab3JHUwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 16:52:41 -0400
Date: Tue, 08 Oct 2013 16:52:39 -0400 (EDT)
Message-Id: <20131008.165239.783847414637978838.davem@davemloft.net>
To: ou.ghorbel@gmail.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv6: Fix the upper MTU limit in GRE tunnel
From: David Miller <davem@davemloft.net>
In-Reply-To: <1381168205-7465-1-git-send-email-ou.ghorbel@gmail.com>
References: <1381168205-7465-1-git-send-email-ou.ghorbel@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 08 Oct 2013 13:52:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oussama Ghorbel <ou.ghorbel@gmail.com>
Date: Mon,  7 Oct 2013 18:50:05 +0100

> Unlike ipv4, the struct member hlen holds the length of the GRE and ipv6
> headers. This length is also counted in dev->hard_header_len.
> Perhaps, it's more clean to modify the hlen to count only the GRE header
> without ipv6 header as the variable name suggest, but the simple way to fix
> this without regression risk is simply modify the calculation of the limit
> in ip6gre_tunnel_change_mtu function.
> Verified in kernel version v3.11.
> 
> Signed-off-by: Oussama Ghorbel <ou.ghorbel@gmail.com>
> Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>

Applied.
