Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251Ab3FBGuU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 02:50:20 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:50005 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab3FBGuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 02:50:16 -0400
Message-ID: <51AAEC11.7090203@linux.vnet.ibm.com>
Date: Sun, 02 Jun 2013 12:24:09 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: gleb@redhat.com, mingo@redhat.com, x86@kernel.org, konrad.wilk@oracle.com,
        hpa@zytor.com, pbonzini@redhat.com, linux-doc@vger.kernel.org,
        habanero@linux.vnet.ibm.com, xen-devel@lists.xensource.com,
        peterz@infradead.org, mtosatti@redhat.com,
        stefano.stabellini@eu.citrix.com, andi@firstfloor.org,
        attilio.rao@citrix.com, ouyang@cs.pitt.edu, gregkh@suse.de,
        agraf@suse.de, chegu_vinod@hp.com, torvalds@linux-foundation.org,
        avi.kivity@gmail.com, tglx@linutronix.de, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stephan.diestelhorst@amd.com,
        riel@redhat.com, drjones@redhat.com,
        virtualization@lists.linux-foundation.org,
        srivatsa.vaddagiri@gmail.com
Subject: Re: [PATCH RFC V9 1/19]  x86/spinlock: Replace pv spinlocks with
 pv ticketlocks
References: <20130601192125.5966.35563.sendpatchset@codeblue> <20130601192138.5966.62276.sendpatchset@codeblue> <51AA5A4E.6090307@goop.org>
In-Reply-To: <51AA5A4E.6090307@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060217-3568-0000-0000-000003B4DC20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2013 02:02 AM, Jeremy Fitzhardinge wrote:
> On 06/01/2013 12:21 PM, Raghavendra K T wrote:
>> x86/spinlock: Replace pv spinlocks with pv ticketlocks
>>
>> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> I'm not sure what the etiquette is here; I did the work while at Citrix,
> but jeremy@goop.org is my canonical email address.  The Citrix address
> is dead and bounces, so is useless for anything.  Probably best to
> change it.
>

Agreed.
I would change to goop address in the next posting.
I had the same doubt for Vatsa's email also. Even I am not sure about
the practice here. So had kept as is.


