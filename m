Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361Ab3HEKiY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 06:38:24 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:44811 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784Ab3HEKiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 06:38:20 -0400
Message-ID: <51FF8180.10207@linux.vnet.ibm.com>
Date: Mon, 05 Aug 2013 16:12:08 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Gleb Natapov <gleb@redhat.com>, mingo@redhat.com, x86@kernel.org,
        tglx@linutronix.de, jeremy@goop.org, konrad.wilk@oracle.com,
        hpa@zytor.com, pbonzini@redhat.com, linux-doc@vger.kernel.org,
        habanero@linux.vnet.ibm.com, xen-devel@lists.xensource.com,
        peterz@infradead.org, mtosatti@redhat.com,
        stefano.stabellini@eu.citrix.com, andi@firstfloor.org,
        attilio.rao@citrix.com, ouyang@cs.pitt.edu, gregkh@suse.de,
        agraf@suse.de, chegu_vinod@hp.com, torvalds@linux-foundation.org,
        avi.kivity@gmail.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, riel@redhat.com, drjones@redhat.com,
        virtualization@lists.linux-foundation.org,
        srivatsa.vaddagiri@gmail.com
Subject: Re: [PATCH RFC V11 15/18] kvm : Paravirtual ticketlocks support for
 linux guests running on KVM hypervisor
References: <20130724120647.GG16400@redhat.com> <51EFCA42.5020009@linux.vnet.ibm.com> <51F0ED31.3040200@linux.vnet.ibm.com> <20130725091509.GA22735@redhat.com> <51F0F202.5090001@linux.vnet.ibm.com> <51F7ED20.80202@linux.vnet.ibm.com> <20130731062440.GK28372@redhat.com> <51FA1087.9080908@linux.vnet.ibm.com> <20130802092539.GB28327@gmail.com> <20130802095406.GB30072@redhat.com> <20130805094603.GA29303@gmail.com>
In-Reply-To: <20130805094603.GA29303@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080510-5490-0000-0000-000003EFD0AA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> That result was only for patch 18 of the series, not pvspinlock in
>> general.
>
> Okay - I've re-read the performance numbers and they are impressive, so no
> objections from me.
>
> The x86 impact seems to be a straightforward API change, with most of the
> changes on the virtualization side. So:
>
> Acked-by: Ingo Molnar <mingo@kernel.org>
>
> I guess you'd want to carry this in the KVM tree or so - maybe in a
> separate branch because it changes Xen as well?
>

Thank you Ingo for taking a relook.

Gleb, Please let me know if you want me to resend the first 17 patches
with acked-bys. i.e excluding the 18th patch.




