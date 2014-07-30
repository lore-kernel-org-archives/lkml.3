Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbaG3PUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 11:20:00 -0400
Received: from g6t1525.atlanta.hp.com ([15.193.200.68]:29506 "EHLO
	g6t1525.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbaG3PT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 11:19:59 -0400
Message-ID: <1406733596.3544.8.camel@j-VirtualBox>
Subject: Re: [PATCH -tip/master 5/7] locking/mutex: Use MUTEX_SPIN_ON_OWNER
 when appropriate
From: Jason Low <jason.low2@hp.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: peterz@infradead.org, mingo@kernel.org, aswin@hp.com,
        linux-kernel@vger.kernel.org
Date: Wed, 30 Jul 2014 08:19:56 -0700
In-Reply-To: <1406524724-17946-5-git-send-email-davidlohr@hp.com>
References: <1406524724-17946-1-git-send-email-davidlohr@hp.com>
	 <1406524724-17946-5-git-send-email-davidlohr@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-07-27 at 22:18 -0700, Davidlohr Bueso wrote:
> 4badad35 (locking/mutex: Disable optimistic spinning on some
> architectures) added a ARCH_SUPPORTS_ATOMIC_RMW flag to
> disable the mutex optimistic feature on specific archs.
> 
> Because CONFIG_MUTEX_SPIN_ON_OWNER only depended on DEBUG and
> SMP, it was ok to have the ->owner field conditional a bit
> flexible. However by adding a new variable to the matter,
> we can waste space with the unused field, ie: CONFIG_SMP &&
> (!CONFIG_MUTEX_SPIN_ON_OWNER && !CONFIG_DEBUG_MUTEX).
> 
> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>

Acked-by: Jason Low <jason.low2@hp.com>

