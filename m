Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760889Ab3EBSGZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 14:06:25 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:48588 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760668Ab3EBSGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 14:06:23 -0400
Date: Thu, 2 May 2013 11:06:20 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: hpa@linux.intel.com
cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        penberg@kernel.org, bp@alien8.de, levinsasha928@gmail.com,
        mtosatti@redhat.com, tglx@linutronix.de, bp@suse.de,
        fengguang.wu@intel.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/kconfig:  Add a Kconfig shortcut for building
 working KVM guest kernels
In-Reply-To: <tip-7e0320e733eec67e40d2b53e438d9971f079862d@git.kernel.org>
Message-ID: <alpine.DEB.2.02.1305021104440.2493@chino.kir.corp.google.com>
References: <20130426095140.GA15361@pd.tnic> <tip-7e0320e733eec67e40d2b53e438d9971f079862d@git.kernel.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 May 2013, tip-bot for Borislav Petkov wrote:

> Commit-ID:  7e0320e733eec67e40d2b53e438d9971f079862d
> Gitweb:     http://git.kernel.org/tip/7e0320e733eec67e40d2b53e438d9971f079862d
> Author:     Borislav Petkov <bp@alien8.de>
> AuthorDate: Fri, 26 Apr 2013 11:51:40 +0200
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Thu, 2 May 2013 10:13:07 -0700
> 
> x86/kconfig: Add a Kconfig shortcut for building working KVM guest kernels
> 
> This is pretty useful for the case where people want to boot the
> resulting kernel in qemu/kvm or lkvm. Instead of going and
> searching for each required option through the Kconfig maze,
> this single option should simply enable everything required/good
> to have to boot the resulting kernel in the guest.
> 
> Patch has been adapted from a version in the external lkvm tree.
> 
> [ hpa: rebased to resolve a merge conflict ]
> 
> Originally-by: Pekka Enberg <penberg@kernel.org>
> Originally-by: Sasha Levin <levinsasha928@gmail.com>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: Sasha Levin <levinsasha928@gmail.com>
> Cc: Fengguang Wu <fengguang.wu@intel.com>
> Link: http://lkml.kernel.org/r/20130426095140.GA15361@pd.tnic
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>

Hi Peter,

You'll also need http://marc.info/?l=linux-kernel&m=136744052328802 when 
Borislav signs it off as it fixes one of the dependencies.  Still waiting 
on how X86_IO_APIC, X86_LOCAL_APIC, and NET_CORE will be resolved.
