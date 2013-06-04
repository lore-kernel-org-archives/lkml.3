Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab3FDKyj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 06:54:39 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:33223 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab3FDKyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 06:54:36 -0400
Message-ID: <51ADC859.6060507@linux.vnet.ibm.com>
Date: Tue, 04 Jun 2013 16:28:33 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: gleb@redhat.com, mingo@redhat.com, jeremy@goop.org, x86@kernel.org,
        konrad.wilk@oracle.com, hpa@zytor.com, pbonzini@redhat.com,
        linux-doc@vger.kernel.org, habanero@linux.vnet.ibm.com,
        xen-devel@lists.xensource.com, peterz@infradead.org,
        mtosatti@redhat.com, stefano.stabellini@eu.citrix.com,
        attilio.rao@citrix.com, ouyang@cs.pitt.edu, gregkh@suse.de,
        agraf@suse.de, chegu_vinod@hp.com, torvalds@linux-foundation.org,
        avi.kivity@gmail.com, tglx@linutronix.de, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, riel@redhat.com, drjones@redhat.com,
        virtualization@lists.linux-foundation.org,
        srivatsa.vaddagiri@gmail.com
Subject: Re: [PATCH RFC V9 0/19] Paravirtualized ticket spinlocks
References: <20130601082145.22955.33596.sendpatchset@codeblue> <20130601201442.GP6123@two.firstfloor.org>
In-Reply-To: <20130601201442.GP6123@two.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060410-7014-0000-0000-0000031D8C67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2013 01:44 AM, Andi Kleen wrote:
>
> FWIW I use the paravirt spinlock ops for adding lock elision
> to the spinlocks.
>
> This needs to be done at the top level (so the level you're removing)
>
> However I don't like the pv mechanism very much and would
> be fine with using an static key hook in the main path
> like I do for all the other lock types.
>
> It also uses interrupt ops patching, for that it would
> be still needed though.
>

Hi Andi, IIUC, you are okay with the current approach overall right?

