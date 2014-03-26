Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695AbaCZBGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 21:06:34 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33290 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755603AbaCZBGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 21:06:32 -0400
Date: Tue, 25 Mar 2014 21:06:30 -0400 (EDT)
Message-Id: <20140325.210630.2082315424643101163.davem@davemloft.net>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Julia.Lawall@lip6.fr,
        akpm@linux-foundation.org, chas@cmf.nrl.navy.mil,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [patch 08/16] atm: idt77105: Use del_timer_sync() in exit path
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140323150753.433572795@linutronix.de>
References: <20140323150557.288925975@linutronix.de>
	<20140323150753.433572795@linutronix.de>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 25 Mar 2014 18:06:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Sun, 23 Mar 2014 15:09:28 -0000

> The module is about to go away. Make sure everything is stopped safely
> before we pull the plug.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Applied.
