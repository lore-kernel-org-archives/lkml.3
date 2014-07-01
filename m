Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785AbaGAGsq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 02:48:46 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59068 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbaGAGso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 02:48:44 -0400
Date: Mon, 30 Jun 2014 23:48:43 -0700 (PDT)
Message-Id: <20140630.234843.985671994258957329.davem@davemloft.net>
To: edward.allcutt@openmarket.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv4: icmp: Fix pMTU handling for rare case
From: David Miller <davem@davemloft.net>
In-Reply-To: <1404141362-21015-1-git-send-email-edward.allcutt@openmarket.com>
References: <1404141362-21015-1-git-send-email-edward.allcutt@openmarket.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Jun 2014 23:48:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Edward Allcutt <edward.allcutt@openmarket.com>
Date: Mon, 30 Jun 2014 16:16:02 +0100

> This is explicitly described as an eventuality that hosts must deal
> with by the standard (RFC 1191) since older standards specified that
> those bits must be zero.
 ...
> One example I have seen is an OpenBSD router terminating IPSec
> tunnels.

Why doesn't OpenBSD implement RFC 1191?

That's a nearly 24 year old standard.

I really don't want to allow for zero values.
