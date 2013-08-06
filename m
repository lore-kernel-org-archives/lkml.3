Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab3HFCoQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 22:44:16 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:41363 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149Ab3HFCoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 22:44:14 -0400
Message-ID: <52006474.6010109@linux.vnet.ibm.com>
Date: Tue, 06 Aug 2013 08:20:28 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: gleb@redhat.com, mingo@redhat.com, jeremy@goop.org, x86@kernel.org,
        konrad.wilk@oracle.com, pbonzini@redhat.com, linux-doc@vger.kernel.org,
        habanero@linux.vnet.ibm.com, xen-devel@lists.xensource.com,
        peterz@infradead.org, mtosatti@redhat.com,
        stefano.stabellini@eu.citrix.com, andi@firstfloor.org,
        attilio.rao@citrix.com, ouyang@cs.pitt.edu, gregkh@suse.de,
        agraf@suse.de, chegu_vinod@hp.com, torvalds@linux-foundation.org,
        avi.kivity@gmail.com, tglx@linutronix.de, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, riel@redhat.com, drjones@redhat.com,
        virtualization@lists.linux-foundation.org,
        srivatsa.vaddagiri@gmail.com
Subject: Re: [PATCH RFC V11 0/18] Paravirtualized ticket spinlocks
References: <20130722061631.24737.75508.sendpatchset@codeblue> <52002C49.1060201@zytor.com>
In-Reply-To: <52002C49.1060201@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080602-8256-0000-0000-000008AAD74D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2013 04:20 AM, H. Peter Anvin wrote:
> So, having read through the entire thread I *think* this is what the
> status of this patchset is:
>
> 1. Patches 1-17 are noncontroversial, Raghavendra is going to send an
>     update split into two patchsets;

Yes.  Only one patch would be common to both host and guest which will
be sent as a separate patch.
I 'll rebase first patchset to -next and second patchset to kvm tree as
needed.

> 2. There are at least two versions of patch 15; I think the "PATCH
>     RESEND RFC" is the right one.

True.

> 3. Patch 18 is controversial but there are performance numbers; these
>     should be integrated in the patch description.

Current plan is to drop for patch 18 for now.

