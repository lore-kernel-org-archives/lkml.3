Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478Ab3FAAKe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 20:10:34 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43193 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715Ab3FAAKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 20:10:25 -0400
Date: Fri, 31 May 2013 17:10:23 -0700 (PDT)
Message-Id: <20130531.171023.192971627043674196.davem@davemloft.net>
To: davidlohr.bueso@hp.com
Cc: edumazet@google.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: skbuff: use _RET_IP_
From: David Miller <davem@davemloft.net>
In-Reply-To: <1369861743.4188.33.camel@buesod1.americas.hpqcorp.net>
References: <1369861743.4188.33.camel@buesod1.americas.hpqcorp.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <davidlohr.bueso@hp.com>
Date: Wed, 29 May 2013 14:09:03 -0700

> Use the already defined macro to pass the function return address.
> 
> Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>

I've decided that we should just leave this alone for now, because
frankly the choice is arbitrary.
