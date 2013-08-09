Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139Ab3HINIO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 09:08:14 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:44712 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758080Ab3HINIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 09:08:11 -0400
Message-ID: <5204EB33.2080704@linux.vnet.ibm.com>
Date: Fri, 09 Aug 2013 18:44:27 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Gleb Natapov <gleb@redhat.com>,
        mingo@redhat.com, jeremy@goop.org, x86@kernel.org, pbonzini@redhat.com,
        linux-doc@vger.kernel.org, habanero@linux.vnet.ibm.com,
        xen-devel@lists.xensource.com, peterz@infradead.org,
        mtosatti@redhat.com, stefano.stabellini@eu.citrix.com,
        andi@firstfloor.org, attilio.rao@citrix.com, ouyang@cs.pitt.edu,
        gregkh@suse.de, agraf@suse.de, chegu_vinod@hp.com,
        torvalds@linux-foundation.org, avi.kivity@gmail.com,
        tglx@linutronix.de, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        riel@redhat.com, drjones@redhat.com,
        virtualization@lists.linux-foundation.org,
        srivatsa.vaddagiri@gmail.com
Subject: Re: [PATCH  V12 0/14] Paravirtualized ticket spinlocks
References: <20130806114020.20643.57235.sendpatchset@codeblue.in.ibm.com> <52016412.1020608@zytor.com> <5201B6FB.5080807@linux.vnet.ibm.com> <5201D180.9080005@zytor.com> <5201ED01.7000803@linux.vnet.ibm.com> <20130808005012.GI2810@phenom.dumpdata.com> <20130808010251.GJ15901@redhat.com> <52040A05.5080107@zytor.com> <520423E9.80507@zytor.com> <5204E57A.3000002@linux.vnet.ibm.com> <20130809130015.GA3730@phenom.dumpdata.com>
In-Reply-To: <20130809130015.GA3730@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080912-0260-0000-0000-000003723CAC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2013 06:30 PM, Konrad Rzeszutek Wilk wrote:
>> My bad. I 'll send out in uniform digit form next time.
>>
>
> If you use 'git format-patch --subject-prefix "PATCH V14" v3.11-rc4..'
> and 'git send-email --subject "[PATCH V14] bla blah" ..'
> that should be automatically taken care of?
>

Thanks Konrad.
Yes. it should. I am planning to use git send-email instead of custom
script.


