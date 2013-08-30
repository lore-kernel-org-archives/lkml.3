Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab3H3IQP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 04:16:15 -0400
Received: from forward15.mail.yandex.net ([95.108.130.119]:35804 "EHLO
	forward15.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529Ab3H3IQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 04:16:13 -0400
From: Alexander Fyodorov <halcy@yandex.ru>
To: Waiman Long <waiman.long@hp.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
In-Reply-To: <52200E7C.5040402@hp.com>
References: <15321377012704@web8h.yandex.ru> <52142D6C.6000400@hp.com> <336901377100289@web16f.yandex.ru> <5215638E.5020702@hp.com> <169431377178121@web21f.yandex.ru> <521BB71F.6080300@hp.com> <66111377605355@web12m.yandex.ru> <521F67C9.4080805@hp.com> <53161377795800@web14m.yandex.ru> <52200E7C.5040402@hp.com>
Subject: Re: [PATCH RFC v2 1/2] qspinlock: Introducing a 4-byte queue spinlock implementation
MIME-Version: 1.0
Message-Id: <152781377850540@web18j.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Fri, 30 Aug 2013 12:15:40 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

30.08.2013, 07:16, "Waiman Long" <waiman.long@hp.com>:
> I am sorry that I was not clear in my previous mail. I mean a flag/macro
> for compile time checking rather than doing runtime checking.

Still a new smp_mb_xxx is better IMO since it can be used in other places too if a need arises.
