Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbaBYARH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 19:17:07 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:48638 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbaBYARD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 19:17:03 -0500
Date: Mon, 24 Feb 2014 19:17:01 -0500 (EST)
Message-Id: <20140224.191701.1833024589083119809.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, stephen@networkplumber.org,
        bart.de.schuymer@pandora.be, pablo@netfilter.org, kaber@trash.net,
        kadlec@blackhole.kfki.hu, bridge@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH 2/2] bridge: netfilter: Use ether_addr_copy
From: David Miller <davem@davemloft.net>
In-Reply-To: <8ffb523682d29d344873ad09b9c27faddcb90b5f.1393142669.git.joe@perches.com>
References: <06d3e7e463c2bbfa8b5264e67daace1181ada090.1393142669.git.joe@perches.com>
	<8ffb523682d29d344873ad09b9c27faddcb90b5f.1393142669.git.joe@perches.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Feb 2014 16:17:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sun, 23 Feb 2014 00:05:26 -0800

> Convert the uses of memcpy to ether_addr_copy because
> for some architectures it is smaller and faster.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
Applied.
