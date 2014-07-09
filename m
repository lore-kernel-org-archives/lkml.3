Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856AbaGIXx3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 19:53:29 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34675 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347AbaGIXx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 19:53:27 -0400
Date: Wed, 09 Jul 2014 16:53:26 -0700 (PDT)
Message-Id: <20140709.165326.390545212542541507.davem@davemloft.net>
To: richard@nod.at
Cc: kys@microsoft.com, haiyangz@microsoft.com,
        sergei.shtylyov@cogentembedded.com, romieu@fr.zoreil.com,
        devel@linuxdriverproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] hyperv: Add netpoll support
From: David Miller <davem@davemloft.net>
In-Reply-To: <1404915839-15940-1-git-send-email-richard@nod.at>
References: <1404915839-15940-1-git-send-email-richard@nod.at>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 09 Jul 2014 16:53:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Weinberger <richard@nod.at>
Date: Wed,  9 Jul 2014 16:23:59 +0200

> In order to have at least a netconsole to debug kernel issues on
> Windows Azure this patch implements netpoll support.
> Sending packets is easy, netvsc_start_xmit() does already everything
> needed.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>

Applied to net-next, thanks.
