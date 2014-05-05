Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbaEEROl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 13:14:41 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59624 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739AbaEEROj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 13:14:39 -0400
Date: Mon, 05 May 2014 13:14:37 -0400 (EDT)
Message-Id: <20140505.131437.1075882730518482984.davem@davemloft.net>
To: acking@vmware.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, gregkh@linuxfoundation.org,
        pv-drivers@vmware.com, stable@vger.kernel.org
Subject: Re: [PATCH] vsock: Make transport the proto owner
From: David Miller <davem@davemloft.net>
In-Reply-To: <1398982843-1453-1-git-send-email-acking@vmware.com>
References: <1398982843-1453-1-git-send-email-acking@vmware.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 05 May 2014 10:14:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy King <acking@vmware.com>
Date: Thu,  1 May 2014 15:20:43 -0700

> Right now the core vsock module is the owner of the proto family. This
> means there's nothing preventing the transport module from unloading if
> there are open sockets, which results in a panic. Fix that by allowing
> the transport to be the owner, which will refcount it properly.
> 
> Includes version bump to 1.0.1.0-k
> 
> Passes checkpatch this time, I swear...
> 
> Cc: stable@vger.kernel.org

Please do not explicitly CC: stable for networking submissions, instead please
just ask me to queue it up for -stable submission since I handle networking
-stable myself.

> Acked-by: Dmitry Torokhov <dtor@vmware.com>
> Signed-off-by: Andy King <acking@vmware.com>

Applied, thanks.
