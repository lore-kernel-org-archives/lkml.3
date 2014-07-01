Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896AbaGATHf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 15:07:35 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34646 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbaGATHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 15:07:33 -0400
Date: Tue, 01 Jul 2014 12:07:30 -0700 (PDT)
Message-Id: <20140701.120730.2210532934459689553.davem@davemloft.net>
To: edward.allcutt@openmarket.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv4: icmp: Fix pMTU handling for rare case
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.2.10.1407011912440.5997@tabini.allcutt.me.uk>
References: <alpine.DEB.2.10.1407010937120.5997@tabini.allcutt.me.uk>
	<20140701.110510.2218293817137911715.davem@davemloft.net>
	<alpine.DEB.2.10.1407011912440.5997@tabini.allcutt.me.uk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 01 Jul 2014 12:07:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Edward Allcutt <edward.allcutt@openmarket.com>
Date: Tue, 1 Jul 2014 19:50:15 +0100 (BST)

> Is there another reason you dislike this approach?

I didn't say I won't apply the patch, actually the email you are
replying to is strictly about figuring out what's happening on
the OpenBSD systems for their sake.
