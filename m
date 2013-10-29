Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab3J2ET5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 00:19:57 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40416 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab3J2ETy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 00:19:54 -0400
Date: Tue, 29 Oct 2013 00:19:53 -0400 (EDT)
Message-Id: <20131029.001953.706692023573797912.davem@davemloft.net>
To: zwu.kernel@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stephen@networkplumber.org, wuzhy@linux.vnet.ibm.com
Subject: Re: [PATCH v2 3/3] net, iovec: fix the incorrect comment in
 memcpy_fromiovecend()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1382940110-10737-3-git-send-email-zwu.kernel@gmail.com>
References: <1382940110-10737-1-git-send-email-zwu.kernel@gmail.com>
	<1382940110-10737-3-git-send-email-zwu.kernel@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 28 Oct 2013 21:19:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <zwu.kernel@gmail.com>
Date: Mon, 28 Oct 2013 14:01:50 +0800

> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Applied to net-next
