Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043Ab3FDO4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:56:20 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:52971 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756045Ab3FDO4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:56:18 -0400
Message-ID: <51AE0101.20408@linux.vnet.ibm.com>
Date: Tue, 04 Jun 2013 20:30:17 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: gleb@redhat.com, mingo@redhat.com, jeremy@goop.org, x86@kernel.org,
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
Subject: Re: [PATCH RFC V9 12/19]  xen: Enable PV ticketlocks on HVM Xen
References: <20130601192125.5966.35563.sendpatchset@codeblue> <20130601192503.5966.70501.sendpatchset@codeblue> <20130603155759.GE4224@phenom.dumpdata.com> <51AD9465.6000508@linux.vnet.ibm.com> <20130604144419.GE7110@phenom.dumpdata.com>
In-Reply-To: <20130604144419.GE7110@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060414-4790-0000-0000-0000089FEC63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2013 08:14 PM, Konrad Rzeszutek Wilk wrote:
> On Tue, Jun 04, 2013 at 12:46:53PM +0530, Raghavendra K T wrote:
>> On 06/03/2013 09:27 PM, Konrad Rzeszutek Wilk wrote:
>>> On Sun, Jun 02, 2013 at 12:55:03AM +0530, Raghavendra K T wrote:
>>>> xen: Enable PV ticketlocks on HVM Xen
>>>
>>> There is more to it. You should also revert 70dd4998cb85f0ecd6ac892cc7232abefa432efb
>>>
>>
>> Yes, true. Do you expect the revert to be folded into this patch itself?
>>
>
> I can do them. I would drop this patch and just mention in
> the cover letter that Konrad would have to revert two git commits
> to re-enable it on PVHVM.
>

Thanks. will do that.

