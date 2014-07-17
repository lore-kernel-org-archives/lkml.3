Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084AbaGQL7g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 07:59:36 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:49014 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755648AbaGQL7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 07:59:34 -0400
Message-ID: <53C7BA82.9020602@de.ibm.com>
Date: Thu, 17 Jul 2014 13:58:58 +0200
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: mingo@kernel.org, dave.anglin@bell.net,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
CC: torvalds@linux-foundation.org, catalin.marinas@arm.com,
        peterz@infradead.org, cmetcalf@tilera.com, jason.low2@hp.com,
        linux@arm.linux.org.uk, tglx@linutronix.de, davidlohr@hp.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com,
        James.Bottomley@hansenpartnership.com, will.deacon@arm.com,
        waiman.long@hp.com, james.hogan@imgtec.com, mpatocka@redhat.com,
        davem@davemloft.net, paulmck@linux.vnet.ibm.com, vgupta@synopsys.com,
        benh@kernel.crashing.org, jejb@parisc-linux.org
Subject: Re: [tip:locking/urgent] locking/mutex:  Disable optimistic spinning
 on some architectures
References: <20140606175316.GV13930@laptop.programming.kicks-ass.net> <tip-4badad352a6bb202ec68afa7a574c0bb961e5ebc@git.kernel.org> <53C7B8AC.2040305@de.ibm.com>
In-Reply-To: <53C7B8AC.2040305@de.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071711-2966-0000-0000-0000008D663E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/07/14 13:51, Christian Borntraeger wrote:

>  	select ARCH_HAVE_NMI_SAFE_CMPXCHG
> +	select ARCH_SUPPORTS_ATOMIC_RMW

This begs the question, if both defines were created for the same reason and could be combined.

Christian

