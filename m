Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbaD1TK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:10:59 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1661 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752461AbaD1TK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:10:56 -0400
Message-ID: <535E8E17.2050600@nod.at>
Date: Mon, 28 Apr 2014 19:21:27 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Randy Dunlap <rdunlap@infradead.org>, Rik van Riel <riel@redhat.com>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, umgwanakikbuti@gmail.com
Subject: Re: mmotm 2014-04-24-13-07 uploaded
References: <20140424200837.727695A407C@corp2gmr1-2.hot.corp.google.com> <535992DD.3060808@infradead.org> <20140425100459.7824f676@annuminas.surriel.com> <535AC91A.1070504@infradead.org> <535ACB0E.4070600@infradead.org> <20140427062650.GW4496@linux.vnet.ibm.com> <20140428135540.GA14661@linux.vnet.ibm.com> <535E8D14.7080405@infradead.org>
In-Reply-To: <535E8D14.7080405@infradead.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 28.04.2014 19:17, schrieb Randy Dunlap:
> 
> uml defconfig on x86_64:
> 
>   CC      arch/um/kernel/asm-offsets.s
> In file included from include/linux/sem.h:5:0,
>                  from include/linux/sched.h:35,
>                  from arch/x86/um/shared/sysdep/kernel-offsets.h:2,
>                  from arch/um/kernel/asm-offsets.c:1:
> include/linux/rcupdate.h:257:20: error: static declaration of 'rcu_sysrq_start' follows non-static declaration
> include/linux/rcupdate.h:250:6: note: previous declaration of 'rcu_sysrq_start' was here
> include/linux/rcupdate.h:260:20: error: static declaration of 'rcu_sysrq_end' follows non-static declaration
> include/linux/rcupdate.h:251:6: note: previous declaration of 'rcu_sysrq_end' was here
> make[2]: *** [arch/um/kernel/asm-offsets.s] Error 1
> 
> 
> Please test your patch(es).

Just in case, to build an x86_64 UML please run:

make defconfig ARCH=um SUBARCH=x86_64
make linux ARCH=um SUBARCH=x86_64

Thanks,
//richard
