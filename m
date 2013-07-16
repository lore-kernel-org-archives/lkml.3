Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964844Ab3GPUDb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 16:03:31 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39694 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933196Ab3GPUDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 16:03:30 -0400
Date: Tue, 16 Jul 2013 13:03:29 -0700 (PDT)
Message-Id: <20130716.130329.1709960351198536948.davem@davemloft.net>
To: jasowang@redhat.com
Cc: mst@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        vyasevic@redhat.com
Subject: Re: [PATCH net 1/2] macvtap: fix the missing ret value of
 TUNSETQUEUE
From: David Miller <davem@davemloft.net>
In-Reply-To: <1373952994-7252-1-git-send-email-jasowang@redhat.com>
References: <1373952994-7252-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 16 Jul 2013 13:03:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Tue, 16 Jul 2013 13:36:33 +0800

> Commit 441ac0fcaadc76ad09771812382345001dd2b813
> (macvtap: Convert to using rtnl lock) forget to return what
> macvtap_ioctl_set_queue() returns to its caller. This may break multiqueue API
> by always falling through to TUNGETFEATURES.
> 
> Cc: Vlad Yasevich <vyasevic@redhat.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Applied.
