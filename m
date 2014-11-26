Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021AbaKZOVi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 09:21:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697AbaKZOVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 09:21:36 -0500
Date: Wed, 26 Nov 2014 15:20:40 +0100
From: Andrew Jones <drjones@redhat.com>
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org,
        marc.zyngier@arm.com, peter.maydell@linaro.org, agraf@suse.de,
        Gleb Natapov <gleb@kernel.org>, jan.kiszka@siemens.com,
        open list <linux-kernel@vger.kernel.org>,
        "open list:ABI/API" <linux-api@vger.kernel.org>,
        dahi@linux.vnet.ibm.com, r65777@freescale.com, pbonzini@redhat.com,
        bp@suse.de
Subject: Re: [PATCH 1/7] KVM: add commentary for kvm_debug_exit_arch struct
Message-ID: <20141126142040.GA3245@hawk.usersys.redhat.com>
References: <1416931805-23223-1-git-send-email-alex.bennee@linaro.org>
 <1416931805-23223-2-git-send-email-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1416931805-23223-2-git-send-email-alex.bennee@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 04:09:59PM +0000, Alex Bennée wrote:
> Bring into line with the commentary for the other structures and their
> KVM_EXIT_* cases.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> 
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 6076882..523f476 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -226,6 +226,7 @@ struct kvm_run {
>  			__u32 count;
>  			__u64 data_offset; /* relative to kvm_run start */
>  		} io;
> +		/* KVM_EXIT_DEBUG */
>  		struct {
>  			struct kvm_debug_exit_arch arch;
>  		} debug;
> -- 
> 2.1.3

Can we change this to a 'KVM: add commentary for kvm exit type data'
patch? We're also missing

/* KVM_EXIT_INTERNAL_ERROR */

and

/* KVM_EXIT_PAPR_HCALL */

> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
