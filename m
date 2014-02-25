Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbaBYDda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 22:33:30 -0500
Received: from ozlabs.org ([203.10.76.45]:47925 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563AbaBYDd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 22:33:28 -0500
In-Reply-To: <1392415338-16288-5-git-send-email-cody@linux.vnet.ibm.com>
To: Cody P Schafer <cody@linux.vnet.ibm.com>,
        Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        Alexander Graf <agraf@suse.de>, Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
From: Michael Ellerman <mpe@ellerman.id.au>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v2 04/11] powerpc: add hvcalls for 24x7 and gpci (get performance counter info)
Message-Id: <20140225033327.878F52C0256@ozlabs.org>
Date: Tue, 25 Feb 2014 14:33:27 +1100 (EST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-14-02 at 22:02:08 UTC, Cody P Schafer wrote:
> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
> ---
>  arch/powerpc/include/asm/hvcall.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/powerpc/include/asm/hvcall.h b/arch/powerpc/include/asm/hvcall.h
> index d8b600b..652f7e4 100644
> --- a/arch/powerpc/include/asm/hvcall.h
> +++ b/arch/powerpc/include/asm/hvcall.h
> @@ -274,6 +274,11 @@
>  /* Platform specific hcalls, used by KVM */
>  #define H_RTAS			0xf000
>  
> +/* "Platform specific hcalls", provided by PHYP */
> +#define H_GET_24X7_CATALOG_PAGE 0xF078
> +#define H_GET_24X7_DATA		0xF07C
> +#define H_GET_PERF_COUNTER_INFO 0xF080

Some tabs some spaces, use tabs.

cheers
