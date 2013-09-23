Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab3IWUqo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 16:46:44 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43547 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819Ab3IWUqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 16:46:42 -0400
Date: Mon, 23 Sep 2013 16:46:40 -0400 (EDT)
Message-Id: <20130923.164640.942004832887018037.davem@davemloft.net>
To: bluezhudong@gmail.com
Cc: richardcochran@gmail.com, rob@landley.net, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4] ptp: add the PTP_SYS_OFFSET ioctl to the
 testptp program
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130917073235.GG23682@zhudong.nay.redhat.com>
References: <20130914153952.GD23682@zhudong.nay.redhat.com>
	<20130915084811.GA10163@netboy>
	<20130917073235.GG23682@zhudong.nay.redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 23 Sep 2013 13:46:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Zhu <bluezhudong@gmail.com>
Date: Tue, 17 Sep 2013 15:32:35 +0800

> This patch add a method into testptp.c to measure the time offset
> between phc and system clock through the ioctl PTP_SYS_OFFSET.
> 
> Signed-off-by: Dong Zhu <bluezhudong@gmail.com>

Applied.
