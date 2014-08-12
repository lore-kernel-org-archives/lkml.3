Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951AbaHLV0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 17:26:36 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39179 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbaHLV0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 17:26:35 -0400
Date: Tue, 12 Aug 2014 14:26:34 -0700 (PDT)
Message-Id: <20140812.142634.745490008512171538.davem@davemloft.net>
To: cj@linux.com
Cc: pshelar@nicira.com, dev@openvswitch.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] openvswitch: Fix memory leak in ovs_vport_alloc()
 error path
From: David Miller <davem@davemloft.net>
In-Reply-To: <1407828477-10287-1-git-send-email-cj@linux.com>
References: <1407828477-10287-1-git-send-email-cj@linux.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 12 Aug 2014 14:26:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Jaeger <cj@linux.com>
Date: Tue, 12 Aug 2014 09:27:57 +0200

> ovs_vport_alloc() bails out without freeing the memory 'vport' points to.
> 
> Picked up by Coverity - CID 1230503.
> 
> Fixes: 5cd667b0a4 ("openvswitch: Allow each vport to have an array of 'port_id's.")
> Signed-off-by: Christoph Jaeger <cj@linux.com>

Applied, thanks.
