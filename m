Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648Ab3F2FMl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 01:12:41 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46379 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab3F2FMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 01:12:05 -0400
Date: Fri, 28 Jun 2013 22:12:04 -0700 (PDT)
Message-Id: <20130628.221204.1514195012349670066.davem@davemloft.net>
To: wangyijing@huawei.com
Cc: linux-kernel@vger.kernel.org, guohanjun@huawei.com, netdev@vger.kernel.org
Subject: Re: [PATCH 2/6] net/trivial: replace numeric with standard PM
 state macros
From: David Miller <davem@davemloft.net>
In-Reply-To: <1372337622-26076-1-git-send-email-wangyijing@huawei.com>
References: <1372337622-26076-1-git-send-email-wangyijing@huawei.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yijing Wang <wangyijing@huawei.com>
Date: Thu, 27 Jun 2013 20:53:42 +0800

> Use standard PM state macros PCI_Dx instead of numeric 0/1/2..
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>

Applied.
