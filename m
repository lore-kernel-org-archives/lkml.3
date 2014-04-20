Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751267AbaDTWTr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 18:19:47 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53931 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbaDTWTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 18:19:24 -0400
Date: Sun, 20 Apr 2014 18:19:23 -0400 (EDT)
Message-Id: <20140420.181923.621422833689356210.davem@davemloft.net>
To: nakayamakenjiro@gmail.com
Cc: linux-kernel@vger.kernel.org, ncardwell@google.com, netdev@vger.kernel.org,
        ycheng@google.com, edumazet@google.com
Subject: Re: [PATCH v3] tcp: Add a TCP_FASTOPEN socket option to get a max
 backlog on its listner
From: David Miller <davem@davemloft.net>
In-Reply-To: <87a9bljl7m.fsf@gmail.com>
References: <87a9bljl7m.fsf@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 20 Apr 2014 15:19:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kenjiro Nakayama <nakayamakenjiro@gmail.com>
Date: Thu, 17 Apr 2014 01:25:01 +0900

> This patch adds a TCP_FASTOPEN socket option to get a max backlog on its
> listener to getsockopt().
> 
> Signed-off-by: Kenjiro Nakayama <nakayamakenjiro@gmail.com>

Applied.
