Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab3H1SB6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 14:01:58 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:41854 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab3H1SB4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 14:01:56 -0400
Date: Wed, 28 Aug 2013 13:01:42 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH V13 4/4] Documentation/kvm : Add documentation on
 Hypercalls and features used for PV spinlock
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: mingo@redhat.com, hpa@zytor.com, x86@kernel.org, gleb@redhat.com,
        pbonzini@redhat.com, jeremy@goop.org, konrad.wilk@oracle.com,
        peterz@infradead.org, tglx@linutronix.de, agraf@suse.de,
        digitaleric@google.com, riel@redhat.com, avi.kivity@gmail.com,
        habanero@linux.vnet.ibm.com, chegu_vinod@hp.com, ouyang@cs.pitt.edu,
        drjones@redhat.com, linux-doc@vger.kernel.org,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, andi@firstfloor.org,
        virtualization@lists.linux-foundation.org, mtosatti@redhat.com,
        srivatsa.vaddagiri@gmail.com,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <y>
	<1377506916-26946-5-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
In-Reply-To: <1377506916-26946-5-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
	(from raghavendra.kt@linux.vnet.ibm.com on Mon Aug 26 03:48:36 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1377712902.2737.137@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2013 03:48:36 AM, Raghavendra K T wrote:
> KVM_HC_KICK_CPU  hypercall added to wakeup halted vcpu in paravirtual  
> spinlock
> enabled guest.
> 
> KVM_FEATURE_PV_UNHALT enables guest to check whether pv spinlock can  
> be enabled
> in guest.
> 
> Thanks Vatsa for rewriting KVM_HC_KICK_CPU
> Cc: Rob Landley <rob@landley.net>

Looks like documentation to me:

Acked-by: Rob Landley <rob@landley.net>

Rob