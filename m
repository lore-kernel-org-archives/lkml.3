Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbaD1Lbm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 07:31:42 -0400
Received: from david.siemens.de ([192.35.17.14]:51784 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462AbaD1Lbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 07:31:35 -0400
Message-ID: <535E3C10.9020403@siemens.com>
Date: Mon, 28 Apr 2014 13:31:28 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Bandan Das <bsd@redhat.com>, kvm@vger.kernel.org
CC: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Emulate VMXON region correctly
References: <1398661204-4822-1-git-send-email-bsd@redhat.com>
In-Reply-To: <1398661204-4822-1-git-send-email-bsd@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-04-28 07:00, Bandan Das wrote:
> Reference: https://bugzilla.kernel.org/show_bug.cgi?id=54521
> 
> The vmxon region is unused by nvmx, but adding these checks
> are probably harmless and may detect buggy L1 hypervisors in 
> the future!

Nice and welcome! Will you provide unit tests for these cases as well?

Jan

> 
> Bandan Das (3):
>   KVM: nVMX: rearrange get_vmx_mem_address
>   KVM: nVMX: additional checks on vmxon region
>   KVM: nVMX: fail on invalid vmclear/vmptrld pointer
> 
>  arch/x86/kvm/vmx.c | 171 ++++++++++++++++++++++++++++++++++++-----------------
>  1 file changed, 118 insertions(+), 53 deletions(-)
> 

-- 
Siemens AG, Corporate Technology, CT RTC ITP SES-DE
Corporate Competence Center Embedded Linux
