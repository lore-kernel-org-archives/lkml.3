Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750887AbaKXV0C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 16:26:02 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:53886 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbaKXV0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 16:26:01 -0500
Date: Mon, 24 Nov 2014 16:25:59 -0500 (EST)
Message-Id: <20141124.162559.644925021702184499.davem@davemloft.net>
To: mst@redhat.com
Cc: linux-kernel@vger.kernel.org, cornelia.huck@de.ibm.com, rusty@au1.ibm.com,
        nab@linux-iscsi.org, pbonzini@redhat.com
Subject: Re: [PATCH v3 00/41] linux: towards virtio-1 guest support
From: David Miller <davem@davemloft.net>
In-Reply-To: <1416829787-14252-1-git-send-email-mst@redhat.com>
References: <1416829787-14252-1-git-send-email-mst@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Nov 2014 13:26:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Mon, 24 Nov 2014 13:52:32 +0200

> David, assuming patches are acceptable, I'd like them all to be merged through
> virtio or vhost trees.  Could you please ack doing that for net related
> patches?

Sure, for the networking bits:

Acked-by: David S. Miller <davem@davemloft.net>
