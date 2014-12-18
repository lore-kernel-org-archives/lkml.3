Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586AbaLRUjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 15:39:17 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:48630 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaLRUjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 15:39:16 -0500
Date: Thu, 18 Dec 2014 15:39:12 -0500 (EST)
Message-Id: <20141218.153912.942123862967427213.davem@davemloft.net>
To: jasowang@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com
Subject: Re: [PATCH net] net: drop the packet when fails to do software
 segmentation or header check
From: David Miller <davem@davemloft.net>
In-Reply-To: <1418882239-6720-1-git-send-email-jasowang@redhat.com>
References: <1418882239-6720-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Dec 2014 12:39:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Thu, 18 Dec 2014 13:57:19 +0800

> Fixes cecda693a969816bac5e470e1d9c9c0ef5567bca

Please correct this fixes tag, it should be of the form:

Fixes: $(SHA1) ("header text of commit message")

The SHA1 ID should be reduced to 12 digits of significance.
