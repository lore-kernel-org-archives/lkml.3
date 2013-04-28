Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab3D1Jnt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 05:43:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156Ab3D1Jns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 05:43:48 -0400
Date: Sun, 28 Apr 2013 12:43:33 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] kvm, svm: Fix typo in printk message
Message-ID: <20130428094333.GE30504@redhat.com>
References: <1366928521-10073-1-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366928521-10073-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 12:22:01AM +0200, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> It is "exit_int_info". It is actually EXITINTINFO in the official docs
> but we don't like screaming docs.
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>
Applied, thanks.

> ---
>  arch/x86/kvm/svm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index a3bba7786ecc..272d29844cc5 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -3491,7 +3491,7 @@ static int handle_exit(struct kvm_vcpu *vcpu)
>  	    exit_code != SVM_EXIT_EXCP_BASE + PF_VECTOR &&
>  	    exit_code != SVM_EXIT_NPF && exit_code != SVM_EXIT_TASK_SWITCH &&
>  	    exit_code != SVM_EXIT_INTR && exit_code != SVM_EXIT_NMI)
> -		printk(KERN_ERR "%s: unexpected exit_ini_info 0x%x "
> +		printk(KERN_ERR "%s: unexpected exit_int_info 0x%x "
>  		       "exit_code 0x%x\n",
>  		       __func__, svm->vmcb->control.exit_int_info,
>  		       exit_code);
> -- 
> 1.8.2.135.g7b592fa
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--
			Gleb.
