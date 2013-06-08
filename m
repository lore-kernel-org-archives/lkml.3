Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751401Ab3FHGt6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 02:49:58 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53564 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab3FHGt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 02:49:56 -0400
Date: Fri, 07 Jun 2013 23:49:50 -0700 (PDT)
Message-Id: <20130607.234950.32504786500736858.davem@davemloft.net>
To: jasowang@redhat.com
Cc: mst@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sergei.shtylyov@cogentembedded.com
Subject: Re: [net-next PATCH 0/8] Multiqueue API for macvtap
From: David Miller <davem@davemloft.net>
In-Reply-To: <1370512480-14272-1-git-send-email-jasowang@redhat.com>
References: <1370512480-14272-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Thu,  6 Jun 2013 17:54:32 +0800

> This series implements a fully tuntap compatiable API which could be used
> by userspace to manage multiple macvtap queues. The main parts is to add
> TUNSETQUEUE ioctl support for macvtap.

Series applied, thanks everyone.
