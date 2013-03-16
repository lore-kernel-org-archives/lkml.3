Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245Ab3CPCHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 22:07:53 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:56241 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104Ab3CPCHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 22:07:51 -0400
Date: Sat, 16 Mar 2013 11:07:47 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/5] Revert
 "KVM: x86: Optimize mmio spte zapping when, creating/moving memslot"
Message-Id: <20130316110747.57fb20e01bcfd890125e2c81@gmail.com>
In-Reply-To: <51433DC3.1070404@linux.vnet.ibm.com>
References: <51433D98.4050605@linux.vnet.ibm.com>
	<51433DC3.1070404@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Mar 2013 23:26:59 +0800
Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d3c4787..61a5bb6 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6991,7 +6991,7 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>  	 * mmio sptes.
>  	 */
>  	if ((change == KVM_MR_CREATE) || (change == KVM_MR_MOVE)) {
> -		kvm_mmu_zap_mmio_sptes(kvm);
> 

???
+ kvm_mmu_zap_all()


	Takuya
