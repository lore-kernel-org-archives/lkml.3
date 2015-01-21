Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbbAUMKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 07:10:31 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:48570 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbbAUMKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 07:10:24 -0500
Message-ID: <54BF96A6.1060702@linux.vnet.ibm.com>
Date: Wed, 21 Jan 2015 17:38:06 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Waiman Long <Waiman.Long@hp.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Scott J Norton <scott.norton@hp.com>,
        Douglas Hatch <doug.hatch@hp.com>
Subject: Re: [PATCH v14 08/11] qspinlock, x86: Rename paravirt_ticketlocks_enabled
References: <1421784755-21945-1-git-send-email-Waiman.Long@hp.com> <1421784755-21945-9-git-send-email-Waiman.Long@hp.com>
In-Reply-To: <1421784755-21945-9-git-send-email-Waiman.Long@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012112-0009-0000-0000-000000D402E3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2015 01:42 AM, Waiman Long wrote:
> This patch renames the paravirt_ticketlocks_enabled static key to a
> more generic paravirt_spinlocks_enabled name.
>
> Signed-off-by: Waiman Long <Waiman.Long@hp.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
Reviewed-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>

