Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab3A2Up1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 15:45:27 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:60069 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab3A2UpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 15:45:24 -0500
Date: Tue, 29 Jan 2013 15:45:23 -0500 (EST)
Message-Id: <20130129.154523.725369676171401650.davem@davemloft.net>
To: jasowang@redhat.com
Cc: mst@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V7 0/3] handle polling errors in vhost/vhost_net
From: David Miller <davem@davemloft.net>
In-Reply-To: <1359371119-10208-1-git-send-email-jasowang@redhat.com>
References: <1359371119-10208-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Mon, 28 Jan 2013 19:05:16 +0800

> This is an update version of last version to fix the handling of polling errors
> in vhost/vhost_net.
> 
> Currently, vhost and vhost_net ignore polling errors which can lead kernel
> crashing when it tries to remove itself from waitqueue after the polling
> failure. Fix this by:
> 
> - examing the POLLERR when setting backend and report erros to userspace
> - let tun always add to waitqueue in .poll() after the queue is created even if
>   it was detached.

Series applied, thanks.
