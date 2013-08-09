Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871Ab3HIMnt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 08:43:49 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:57134 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756784Ab3HIMnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 08:43:46 -0400
Message-ID: <5204E57A.3000002@linux.vnet.ibm.com>
Date: Fri, 09 Aug 2013 18:20:02 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Gleb Natapov <gleb@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, mingo@redhat.com,
        jeremy@goop.org, x86@kernel.org, pbonzini@redhat.com,
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
References: <20130806114020.20643.57235.sendpatchset@codeblue.in.ibm.com> <52016412.1020608@zytor.com> <5201B6FB.5080807@linux.vnet.ibm.com> <5201D180.9080005@zytor.com> <5201ED01.7000803@linux.vnet.ibm.com> <20130808005012.GI2810@phenom.dumpdata.com> <20130808010251.GJ15901@redhat.com> <52040A05.5080107@zytor.com> <520423E9.80507@zytor.com>
In-Reply-To: <520423E9.80507@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080912-5564-0000-0000-00000930C8BA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2013 04:34 AM, H. Peter Anvin wrote:
>
> Okay, I figured it out.
>
> One of several problems with the formatting of this patchset is that it
> has one- and two-digit patch numbers in the headers, which meant that my
> scripts tried to apply patch 10 first.
>

My bad. I 'll send out in uniform digit form next time.

