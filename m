Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457AbaCDS5L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 13:57:11 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:35853 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122AbaCDS5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 13:57:09 -0500
Date: Tue, 04 Mar 2014 13:57:06 -0500 (EST)
Message-Id: <20140304.135706.1524293483444485183.davem@davemloft.net>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        sparclinux@vger.kernel.org
Subject: Re: [patch 13/26] sparc: Use the core irq stats function
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140223212737.635609567@linutronix.de>
References: <20140223212703.511977310@linutronix.de>
	<20140223212737.635609567@linutronix.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Mar 2014 10:57:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Sun, 23 Feb 2014 21:40:15 -0000

> Let the core do the irq_desc resolution.
> 
> No functional change.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: sparc <sparclinux@vger.kernel.org>

Acked-by: David S. Miller <davem@davemloft.net>
