Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab3J2ETu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 00:19:50 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40411 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330Ab3J2ETr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 00:19:47 -0400
Date: Tue, 29 Oct 2013 00:19:45 -0400 (EDT)
Message-Id: <20131029.001945.1419201595433912995.davem@davemloft.net>
To: zwu.kernel@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stephen@networkplumber.org, wuzhy@linux.vnet.ibm.com
Subject: Re: [PATCH v2 2/3] net, datagram: fix the incorrect comment in
 zerocopy_sg_from_iovec()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1382940110-10737-2-git-send-email-zwu.kernel@gmail.com>
References: <1382940110-10737-1-git-send-email-zwu.kernel@gmail.com>
	<1382940110-10737-2-git-send-email-zwu.kernel@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 28 Oct 2013 21:19:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <zwu.kernel@gmail.com>
Date: Mon, 28 Oct 2013 14:01:49 +0800

> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Applied to net-next.
