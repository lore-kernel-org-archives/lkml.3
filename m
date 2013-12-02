Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab3LBB2Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 20:28:24 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:45375 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab3LBB2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 20:28:21 -0500
Date: Sun, 01 Dec 2013 20:28:20 -0500 (EST)
Message-Id: <20131201.202820.1535300264634944655.davem@davemloft.net>
To: mst@redhat.com
Cc: linux-kernel@vger.kernel.org, jasowang@redhat.com, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 2/2] virtio-net: make all RX paths handle erors
 consistently
From: David Miller <davem@davemloft.net>
In-Reply-To: <1385638044-27467-2-git-send-email-mst@redhat.com>
References: <1385638044-27467-1-git-send-email-mst@redhat.com>
	<1385638044-27467-2-git-send-email-mst@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Sun, 01 Dec 2013 17:28:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Thu, 28 Nov 2013 13:30:59 +0200

> receive mergeable now handles errors internally.
> Do same for big and small packet paths, otherwise
> the logic is too hard to follow.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Acked-by: Jason Wang <jasowang@redhat.com>

Applied and I fixed the subject text to use an underscore '_' instead
of a dash '-' for "virtio_net: ".
