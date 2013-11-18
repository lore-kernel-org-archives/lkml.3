Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964Ab3KRVXe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 16:23:34 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:50090 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab3KRVXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 16:23:31 -0500
Date: Mon, 18 Nov 2013 16:23:28 -0500 (EST)
Message-Id: <20131118.162328.1843423306778203148.davem@davemloft.net>
To: zwu.kernel@gmail.com
Cc: netdev@vger.kernel.org, mst@redhat.com, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, wuzhy@linux.vnet.ibm.com
Subject: Re: [PATCH] net, virtio_net: replace the magic value
From: David Miller <davem@davemloft.net>
In-Reply-To: <1384780767-25507-1-git-send-email-zwu.kernel@gmail.com>
References: <1384780767-25507-1-git-send-email-zwu.kernel@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 18 Nov 2013 13:23:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <zwu.kernel@gmail.com>
Date: Mon, 18 Nov 2013 21:19:27 +0800

> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
> It is more appropriate to use # of queue pairs currently used by
> the driver instead of a magic value.
> 
> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>

Applied, thanks.
