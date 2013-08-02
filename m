Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab3HBKvF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:51:05 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:46844 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650Ab3HBKu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:50:59 -0400
Message-ID: <51FB9088.8010302@linux.vnet.ibm.com>
Date: Fri, 02 Aug 2013 16:27:12 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        peterz@infradead.org
CC: mingo@redhat.com, x86@kernel.org, tglx@linutronix.de, jeremy@goop.org,
        konrad.wilk@oracle.com, hpa@zytor.com, pbonzini@redhat.com,
        linux-doc@vger.kernel.org, habanero@linux.vnet.ibm.com,
        xen-devel@lists.xensource.com, mtosatti@redhat.com,
        stefano.stabellini@eu.citrix.com, andi@firstfloor.org,
        attilio.rao@citrix.com, ouyang@cs.pitt.edu, gregkh@suse.de,
        agraf@suse.de, chegu_vinod@hp.com, torvalds@linux-foundation.org,
        avi.kivity@gmail.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, riel@redhat.com, drjones@redhat.com,
        virtualization@lists.linux-foundation.org,
        srivatsa.vaddagiri@gmail.com
Subject: Re: [PATCH RFC V11 15/18] kvm : Paravirtual ticketlocks support for
 linux guests running on KVM hypervisor
References: <51EFC1D4.9060800@linux.vnet.ibm.com> <20130724120647.GG16400@redhat.com> <51EFCA42.5020009@linux.vnet.ibm.com> <51F0ED31.3040200@linux.vnet.ibm.com> <20130725091509.GA22735@redhat.com> <51F0F202.5090001@linux.vnet.ibm.com> <51F7ED20.80202@linux.vnet.ibm.com> <20130731062440.GK28372@redhat.com> <51FA1087.9080908@linux.vnet.ibm.com> <20130802092539.GB28327@gmail.com> <20130802095406.GB30072@redhat.com>
In-Reply-To: <20130802095406.GB30072@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080210-9264-0000-0000-00000440B9B3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2013 03:24 PM, Gleb Natapov wrote:
> On Fri, Aug 02, 2013 at 11:25:39AM +0200, Ingo Molnar wrote:
>>> Ingo,
>>>
>>> Do you have any concerns reg this series? please let me know if this
>>> looks good now to you.
>>
>> I'm inclined to NAK it for excessive quotation - who knows how many people
>> left the discussion in disgust? Was it done to drive away as many
>> reviewers as possible?

Ingo, Peter,
Sorry for the confusion caused because of nesting. I should have trimmed 
it as Peter also pointed in other thread.
will ensure that is future mails.


>> Anyway, see my other reply, the measurement results seem hard to interpret
>> and inconclusive at the moment.

As Gleb already pointed, patch1-17 as a whole giving good performance 
improvement. It was only the patch 18, Gleb had concerns.

