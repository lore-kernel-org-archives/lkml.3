Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094AbaKUT7f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 14:59:35 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38216 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbaKUT7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 14:59:34 -0500
Date: Fri, 21 Nov 2014 14:59:32 -0500 (EST)
Message-Id: <20141121.145932.1019989098659258075.davem@davemloft.net>
To: jasowang@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        herbert@gondor.apana.org.au
Subject: Re: [PATCH net-next] macvtap: advance iov iterator when needed in
 macvtap_put_user()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1416472265-10151-1-git-send-email-jasowang@redhat.com>
References: <1416472265-10151-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 21 Nov 2014 11:59:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Thu, 20 Nov 2014 16:31:05 +0800

> When mergeable buffer is used, vnet_hdr_sz is greater than sizeof struct
> virtio_net_hdr. So we need advance the iov iterators in this case.
> 
> Fixes 6c36d2e26cda1ad3e2c4b90dd843825fc62fe5b4 ("macvtap: Use iovec iterators")
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Applied, thanks.
