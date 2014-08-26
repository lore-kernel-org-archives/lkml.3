Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796AbaHZAX4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 20:23:56 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39783 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbaHZAXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 20:23:55 -0400
Date: Mon, 25 Aug 2014 17:23:53 -0700 (PDT)
Message-Id: <20140825.172353.145857012627747535.davem@davemloft.net>
To: mkubecek@suse.cz
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] net: fix checksum features handling in
 netif_skb_features()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140825131622.6233CA0BB0@unicorn.suse.cz>
References: <20140821.163320.476216950054835385.davem@davemloft.net>
	<20140825131622.6233CA0BB0@unicorn.suse.cz>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 25 Aug 2014 17:23:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Kubecek <mkubecek@suse.cz>
Date: Mon, 25 Aug 2014 15:16:22 +0200 (CEST)

> This is follow-up to
> 
>   da08143b8520 ("vlan: more careful checksum features handling")
> 
> which introduced more careful feature intersection in vlan code,
> taking into account that HW_CSUM should be considered superset
> of IP_CSUM/IPV6_CSUM. The same is needed in netif_skb_features()
> in order to avoid offloading mismatch warning when vlan is
> created on top of a bond consisting of slaves supporting IP/IPv6
> checksumming but not vlan Tx offloading.
> 
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Applied and queued up for -stable, thanks.
