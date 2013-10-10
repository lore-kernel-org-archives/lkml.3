Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188Ab3JJERZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 00:17:25 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56155 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab3JJERY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 00:17:24 -0400
Date: Thu, 10 Oct 2013 00:17:22 -0400 (EDT)
Message-Id: <20131010.001722.880038875298978753.davem@davemloft.net>
To: baker.kernel@gmail.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] fib_trie: only calc for the un-first node
From: David Miller <davem@davemloft.net>
In-Reply-To: <1381203411-12047-1-git-send-email-baker.kernel@gmail.com>
References: <1381203411-12047-1-git-send-email-baker.kernel@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 09 Oct 2013 21:17:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: baker.kernel@gmail.com
Date: Tue,  8 Oct 2013 11:36:51 +0800

> From: "baker.zhang" <baker.kernel@gmail.com>
> 
> This is a enhancement.
> 
> for the first node in fib_trie, newpos is 0, bit is 1.
> Only for the leaf or node with unmatched key need calc pos.
> 
> Signed-off-by: baker.zhang <baker.kernel@gmail.com>

The compiler is probably doing this transformation all by itself,
but applied anyways, thanks.
