Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074Ab3DLS7G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 14:59:06 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52427 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab3DLS7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 14:59:04 -0400
Date: Fri, 12 Apr 2013 14:59:02 -0400 (EDT)
Message-Id: <20130412.145902.808700335606305579.davem@davemloft.net>
To: jasowang@redhat.com
Cc: ian.campbell@citrix.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH] xen-netback: switch to use
 skb_partial_csum_set()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1365662129-38031-1-git-send-email-jasowang@redhat.com>
References: <1365662129-38031-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Fri, 12 Apr 2013 11:59:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Thu, 11 Apr 2013 14:35:29 +0800

> Switch to use skb_partial_csum_set() to simplify the codes.
> 
> Cc: Ian Campbell <ian.campbell@citrix.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Applied, thanks Jason.
