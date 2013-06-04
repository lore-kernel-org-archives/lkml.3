Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759930Ab3FDHLc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 03:11:32 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:44714 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759292Ab3FDHL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 03:11:29 -0400
Message-ID: <51AD941D.906@linux.vnet.ibm.com>
Date: Tue, 04 Jun 2013 12:45:41 +0530
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
Subject: Re: [PATCH RFC V9 9/19]  Split out rate limiting from jump_label.h
References: <20130601192125.5966.35563.sendpatchset@codeblue> <20130601192422.5966.44354.sendpatchset@codeblue> <20130603155612.GD4224@phenom.dumpdata.com>
In-Reply-To: <20130603155612.GD4224@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060407-2000-0000-0000-00000C5DBF25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2013 09:26 PM, Konrad Rzeszutek Wilk wrote:
> On Sun, Jun 02, 2013 at 12:54:22AM +0530, Raghavendra K T wrote:
>> Split jumplabel ratelimit
>
> I would change the title a bit, perhaps prefix it with: "jump_label: "
>>
>> From: Andrew Jones <drjones@redhat.com>
>>
>> Commit b202952075f62603bea9bfb6ebc6b0420db11949 introduced rate limiting
>
> Also please add right after the git id this:
>
> ("perf, core: Rate limit perf_sched_events jump_label patching")

Agreed.

