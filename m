Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960AbaB0LUR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:20:17 -0500
Received: from goliath.siemens.de ([192.35.17.28]:39381 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbaB0LUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:20:15 -0500
Message-ID: <530F1F55.1020209@siemens.com>
Date: Thu, 27 Feb 2014 12:19:49 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org
CC: kvm@vger.kernel.org, mtosatti@redhat.com, gleb@kernel.org,
        Liu Jinsong <jinsong.liu@intel.com>
Subject: Re: [PATCH v2 0/2] KVM: x86: more xsave and mpx improvements
References: <1393433681-22888-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1393433681-22888-1-git-send-email-pbonzini@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-02-26 17:54, Paolo Bonzini wrote:
> Here are the patches I mentioned while reviewing Liu Jinsong's MPX
> series.
> 
> Patch 1 is a further cleanup of xcr0 handling, and patch 2 introduces
> nested virtualization support for MPX.
> 
> Please review.
> 
> Thanks,
> 
> Paolo
> 
> Paolo Bonzini (2):
>   KVM: x86: introduce kvm_supported_xcr0()
>   KVM: x86: Add nested virtualization support for MPX
> 
>  arch/x86/kvm/cpuid.c | 27 ++++++++++++++++-----------
>  arch/x86/kvm/vmx.c   | 17 +++++++++++++++++
>  arch/x86/kvm/x86.c   |  4 +---
>  arch/x86/kvm/x86.h   |  2 ++
>  4 files changed, 36 insertions(+), 14 deletions(-)
> 

Is this round different from the other v2?

Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SES-DE
Corporate Competence Center Embedded Linux
