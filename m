Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbaCZBG3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 21:06:29 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33278 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755318AbaCZBG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 21:06:27 -0400
Date: Tue, 25 Mar 2014 21:06:25 -0400 (EDT)
Message-Id: <20140325.210625.2118615732170549372.davem@davemloft.net>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Julia.Lawall@lip6.fr,
        akpm@linux-foundation.org, chas@cmf.nrl.navy.mil,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [patch 07/16] atm: firestream: Use del_timer_sync() in
 teardown path
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140323150753.325835408@linutronix.de>
References: <20140323150557.288925975@linutronix.de>
	<20140323150753.325835408@linutronix.de>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 25 Mar 2014 18:06:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Sun, 23 Mar 2014 15:09:28 -0000

> The device is about to vanish. So we need to make sure that the timer
> is completely stopped and the callback is not running on another CPU.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Applied.
