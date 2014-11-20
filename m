Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626AbaKTAA7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 19:00:59 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:40040 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658AbaKTAA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 19:00:58 -0500
Date: Wed, 19 Nov 2014 19:00:55 -0500 (EST)
Message-Id: <20141119.190055.951482077687787545.davem@davemloft.net>
To: jasowang@redhat.com
Cc: cornelia.huck@de.ibm.com, rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gaowanlong@cn.fujitsu.com
Subject: Re: [PATCH V2 net] virtio-net: validate features during probe
From: David Miller <davem@davemloft.net>
In-Reply-To: <546C612A.4080807@redhat.com>
References: <1416381689-2025-1-git-send-email-jasowang@redhat.com>
	<20141119095445.32d94d5d.cornelia.huck@de.ibm.com>
	<546C612A.4080807@redhat.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Nov 2014 16:00:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Wed, 19 Nov 2014 17:21:46 +0800

> More compact, looks good. Thanks

I am assuming there is therefore a V3 of this patch forthcoming.
