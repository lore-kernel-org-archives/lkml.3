Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab3LQTqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 14:46:18 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:48443 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921Ab3LQTqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 14:46:16 -0500
Date: Tue, 17 Dec 2013 14:46:14 -0500 (EST)
Message-Id: <20131217.144614.1217520884557723259.davem@davemloft.net>
To: jasowang@redhat.com
Cc: kys@microsoft.com, haiyangz@microsoft.com, devel@linuxdriverproject.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] netvsc: don't flush peers notifying work during
 setting mtu
From: David Miller <davem@davemloft.net>
In-Reply-To: <1386926487-30822-1-git-send-email-jasowang@redhat.com>
References: <1386926487-30822-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 17 Dec 2013 11:46:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Fri, 13 Dec 2013 17:21:27 +0800

> There's a possible deadlock if we flush the peers notifying work during setting
> mtu:
 ...
> Reported-by: Yaju Cao <yacao@redhat.com>
> Tested-by: Yaju Cao <yacao@redhat.com>
> Cc: K. Y. Srinivasan <kys@microsoft.com>
> Cc: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
> The patch is needed for stable.

Applied and queued up for -stable, thanks Jason.
