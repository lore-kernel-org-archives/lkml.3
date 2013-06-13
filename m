Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758354Ab3FMIXk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 04:23:40 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37561 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758332Ab3FMIXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 04:23:37 -0400
Date: Thu, 13 Jun 2013 01:23:36 -0700 (PDT)
Message-Id: <20130613.012336.1431021696375181869.davem@davemloft.net>
To: jasowang@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, edumazet@google.com
Subject: Re: [net-next PATCH V2 2/2] macvtap: fix uninitialized return
 value macvtap_ioctl_set_queue()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1371104616-18319-2-git-send-email-jasowang@redhat.com>
References: <1371104616-18319-1-git-send-email-jasowang@redhat.com>
	<1371104616-18319-2-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Thu, 13 Jun 2013 14:23:36 +0800

> Return -EINVAL on illegal flag instead of uninitialized value. This fixes the
> kbuild test warning.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Applied.
