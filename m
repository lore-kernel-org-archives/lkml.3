Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933647Ab3CSSQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 14:16:05 -0400
Received: from www.linutronix.de ([62.245.132.108]:46976 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933418Ab3CSSQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 14:16:03 -0400
Message-ID: <5148AB59.6080000@linutronix.de>
Date: Tue, 19 Mar 2013 19:15:53 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
Subject: Re: [PATCH 1/3] kernel/srcu: merge common code into a macro
References: <1363702606-31586-1-git-send-email-bigeasy@linutronix.de> <1363710160.1932.49.camel@joe-AO722>
In-Reply-To: <1363710160.1932.49.camel@joe-AO722>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2013 05:22 PM, Joe Perches wrote:
>> +#define DEFINE_SRCU(name)		_DEFINE_SRCU(name, )
>> +#define DEFINE_STATIC_SRCU(name)	_DEFINE_SRCU(name, static)
> 
> I think the use of an empty argument, even in
> a macro, unsightly.

__wait_event_lock_irq() => __wait_event_lock_irq() is a prominent user.
I would prefer to avoid adding something like /* nothing */.

Sebastian
