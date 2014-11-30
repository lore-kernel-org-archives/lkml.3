Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976AbaK3FAQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 00:00:16 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:54880 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaK3FAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 00:00:14 -0500
Date: Sat, 29 Nov 2014 21:04:22 -0800 (PST)
Message-Id: <20141129.210422.2298555198780052887.davem@davemloft.net>
To: jasowang@redhat.com
Cc: mst@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH net-next] vhost: remove unnecessary forward
 declarations in vhost.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <1417070481-10331-1-git-send-email-jasowang@redhat.com>
References: <1417070481-10331-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 29 Nov 2014 21:00:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Thu, 27 Nov 2014 14:41:21 +0800

> Signed-off-by: Jason Wang <jasowang@redhat.com>

I don't think generic vhost patches should go via my tree.

If you disagree, let me know why, thanks :)
