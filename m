Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab3JBVIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 17:08:06 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49448 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157Ab3JBVIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 17:08:04 -0400
Date: Wed, 02 Oct 2013 17:07:57 -0400 (EDT)
Message-Id: <20131002.170757.855953378869304259.davem@davemloft.net>
To: mst@redhat.com
Cc: jasowang@redhat.com, rusty@rustcorp.com.au, edumazet@google.com,
        jiri@resnulli.us, vyasevic@redhat.com, amwang@redhat.com,
        alexander.h.duyck@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netif_set_xps_queue: make cpu mask const
From: David Miller <davem@davemloft.net>
In-Reply-To: <20131002061406.GA8809@redhat.com>
References: <20131002061406.GA8809@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 02 Oct 2013 14:07:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Wed, 2 Oct 2013 09:14:06 +0300

> virtio wants to pass in cpumask_of(cpu), make parameter
> const to avoid build warnings.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Refresh my memory, is to accomodate a change you want to submit to
'net' or 'net-next'?  This patch only applies to 'net' cleanly.
