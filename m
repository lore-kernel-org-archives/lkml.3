Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933438Ab3HGXro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 19:47:44 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51547 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932926Ab3HGXrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 19:47:43 -0400
Date: Wed, 07 Aug 2013 16:52:57 -0700 (PDT)
Message-Id: <20130807.165257.2178020819318828004.davem@davemloft.net>
To: jasowang@redhat.com
Cc: mst@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next 0/6] Reduce code duplication of zerocopy of tun and
 macvtap
From: David Miller <davem@davemloft.net>
In-Reply-To: <1375782308-10565-1-git-send-email-jasowang@redhat.com>
References: <1375782308-10565-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 07 Aug 2013 16:47:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Tue,  6 Aug 2013 17:45:02 +0800

> This series tries to reduce the code duplication of zerocopy of tun and macvtap
> by:
> 
> - Move common helpers iov_pages() and zerocopy_sg_from_iovec() to net/core
> - Use exist helpers instead of open coding the new one
> 
> With this seires, we can do further optimizations on top.

Looks great, applied!
