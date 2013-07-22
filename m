Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933251Ab3GVTiA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 15:38:00 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:40938 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932820Ab3GVTh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 15:37:58 -0400
Date: Mon, 22 Jul 2013 15:36:27 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: gleb@redhat.com, mingo@redhat.com, jeremy@goop.org, x86@kernel.org,
        hpa@zytor.com, pbonzini@redhat.com, linux-doc@vger.kernel.org,
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
Message-ID: <20130722193627.GP30300@phenom.dumpdata.com>
References: <20130722061631.24737.75508.sendpatchset@codeblue>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130722061631.24737.75508.sendpatchset@codeblue>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> github link: https://github.com/ktraghavendra/linux/tree/pvspinlock_v11

And chance you have a backup git tree? I get:

This repository is temporarily unavailable.

> 
> Please note that we set SPIN_THRESHOLD = 32k with this series,
> that would eatup little bit of overcommit performance of PLE machines
> and overall performance of non-PLE machines.
> 
> The older series[3] was tested by Attilio for Xen implementation.
> 
> Note that Konrad needs to revert below two patches to enable xen on hvm 
>   70dd4998, f10cd522c

We could add that to the series. But let me first test it out - and that
gets back to the repo :-)
