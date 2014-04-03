Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbaDCQav (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 12:30:51 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45279 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbaDCQas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 12:30:48 -0400
Date: Thu, 03 Apr 2014 12:32:19 -0400 (EDT)
Message-Id: <20140403.123219.186974875530426005.davem@davemloft.net>
To: jwboyer@fedoraproject.org
Cc: mugunthanvnm@ti.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: cpts: Add includes for ETH_HLEN and VLAN_HLEN
 definitions
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140403160843.GD15134@hansolo.jdub.homelinux.org>
References: <20140403160843.GD15134@hansolo.jdub.homelinux.org>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 03 Apr 2014 09:30:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Boyer <jwboyer@fedoraproject.org>
Date: Thu, 3 Apr 2014 12:08:43 -0400

> If CONFIG_TI_CPTS is enabled, the ti_cpsw driver will fail to build with:
> 
> drivers/net/ethernet/ti/cpts.c: In function 'cpts_match':
> drivers/net/ethernet/ti/cpts.c:266:12: error: 'ETH_HLEN' undeclared (first use in this function)
>    offset = ETH_HLEN + IPV4_HLEN(data) + UDP_HLEN;
>             ^
> drivers/net/ethernet/ti/cpts.c:266:12: note: each undeclared identifier is reported only once for each function it appears in
> drivers/net/ethernet/ti/cpts.c:276:23: error: 'VLAN_HLEN' undeclared (first use in this function)
>    offset = ETH_HLEN + VLAN_HLEN;
>                        ^
> 
> Add includes of if_ether.h and if_vlan.h to bring in the appropriate defines.
> 
> Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>

A patch for this was already submitted to netdev and applied to the 'net'
GIT tree earlier today.
