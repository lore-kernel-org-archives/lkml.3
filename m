Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633Ab3HFVHD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 17:07:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43153 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305Ab3HFVHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 17:07:01 -0400
Message-ID: <52016412.1020608@zytor.com>
Date: Tue, 06 Aug 2013 14:01:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
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
Subject: Re: [PATCH  V12 0/14] Paravirtualized ticket spinlocks
References: <20130806114020.20643.57235.sendpatchset@codeblue.in.ibm.com>
In-Reply-To: <20130806114020.20643.57235.sendpatchset@codeblue.in.ibm.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2013 04:40 AM, Raghavendra K T wrote:
> This series replaces the existing paravirtualized spinlock mechanism
> with a paravirtualized ticketlock mechanism. The series provides
> implementation for both Xen and KVM.
> 
> The current set of patches are for Xen/x86 spinlock/KVM guest side, to be included
> against -tip.
> 

What is the baseline for this patchset?  I tried to apply it on top of
3.11-rc4 and I got nontrivial conflicts.

	-hpa


