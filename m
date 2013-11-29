Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab3K2Vjc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 16:39:32 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:54938 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712Ab3K2Vjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 16:39:31 -0500
Date: Fri, 29 Nov 2013 16:39:30 -0500 (EST)
Message-Id: <20131129.163930.203685593163996122.davem@davemloft.net>
To: hannes@stressinduktion.org
Cc: kamala@aristanetworks.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv6: ip6_pkt_prohibit(_out) should not depend on
 CONFIG_IPV6_MULTIPLE_TABLES
From: David Miller <davem@davemloft.net>
In-Reply-To: <20131128190411.GD24171@order.stressinduktion.org>
References: <1385629923-22920-1-git-send-email-kamala@aristanetwors.com>
	<20131128190411.GD24171@order.stressinduktion.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 29 Nov 2013 13:39:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Frederic Sowa <hannes@stressinduktion.org>
Date: Thu, 28 Nov 2013 20:04:11 +0100

> Since patch "IPv6: Fixed support for blackhole and prohibit routes" we
> need ip6_pkt_prohibit(_out) available without CONFIG_IPV6_MULTIPLE_TABLES
> defined.
> 
> Cc: Kamala R <kamala@aristanetworks.com>
> Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>

Please reference the SHA1 ID of the change as well as it's commit
header text, thank you.
