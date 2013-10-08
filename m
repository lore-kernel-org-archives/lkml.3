Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab3JHTqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 15:46:17 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54249 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab3JHTqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 15:46:15 -0400
Date: Tue, 08 Oct 2013 15:46:14 -0400 (EDT)
Message-Id: <20131008.154614.1435858706789904414.davem@davemloft.net>
To: mst@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jasowang@redhat.com,
        edumazet@google.com, xemul@parallels.com
Subject: Re: [PATCH] tun: don't look at current when non-blocking
From: David Miller <davem@davemloft.net>
In-Reply-To: <20131006182512.GA16504@redhat.com>
References: <20131006182512.GA16504@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 08 Oct 2013 12:46:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Sun, 6 Oct 2013 21:25:12 +0300

> We play with a wait queue even if socket is
> non blocking. This is an obvious waste.
> Besides, it will prevent calling the non blocking
> variant when current is not valid.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Applied and queued up for -stable, thanks.
