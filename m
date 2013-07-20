Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab3GTAhX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 20:37:23 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54449 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab3GTAhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 20:37:22 -0400
Date: Fri, 19 Jul 2013 17:37:21 -0700 (PDT)
Message-Id: <20130719.173721.850231910179318409.davem@davemloft.net>
To: mtesar@redhat.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] sysctl net: Keep tcp_syn_retries inside the boundary
From: David Miller <davem@davemloft.net>
In-Reply-To: <1374235741-31266-1-git-send-email-mtesar@redhat.com>
References: <1374235741-31266-1-git-send-email-mtesar@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 19 Jul 2013 17:37:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Tesar <mtesar@redhat.com>
Date: Fri, 19 Jul 2013 14:09:01 +0200

> Limit the min/max value passed to the
> /proc/sys/net/ipv4/tcp_syn_retries.
> 
> Signed-off-by: Michal Tesar <mtesar@redhat.com>

Applied and queued up for -stable.
