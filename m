Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab3AJXBE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 18:01:04 -0500
Received: from gate.crashing.org ([63.228.1.57]:55790 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753427Ab3AJXBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 18:01:03 -0500
Message-ID: <1357858846.4838.92.camel@pasglop>
Subject: Re: [PATCH] PowerPC documentation: fixed path to the powerpc
 directory
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Thomas Waldecker <thomas.waldecker@gmail.com>
Cc: paulus@samba.org, rob@landley.net, linuxppc-dev@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 11 Jan 2013 10:00:46 +1100
In-Reply-To: <1357819632-30814-1-git-send-email-thomas.waldecker@gmail.com>
References: <1357819632-30814-1-git-send-email-thomas.waldecker@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-10 at 13:07 +0100, Thomas Waldecker wrote:
> ppc -> powerpc

I think I already applied something like that in powerpc -next, can you
dbl check ?

Cheers,
Ben.

> Signed-off-by: Thomas Waldecker <thomas.waldecker@gmail.com>
> ---
>  Documentation/powerpc/cpu_features.txt | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/powerpc/cpu_features.txt b/Documentation/powerpc/cpu_features.txt
> index ffa4183..ae09df8 100644
> --- a/Documentation/powerpc/cpu_features.txt
> +++ b/Documentation/powerpc/cpu_features.txt
> @@ -11,10 +11,10 @@ split instruction and data caches, and if the CPU supports the DOZE and NAP
>  sleep modes.
>  
>  Detection of the feature set is simple. A list of processors can be found in
> -arch/ppc/kernel/cputable.c. The PVR register is masked and compared with each
> -value in the list. If a match is found, the cpu_features of cur_cpu_spec is
> -assigned to the feature bitmask for this processor and a __setup_cpu function
> -is called.
> +arch/powerpc/kernel/cputable.c. The PVR register is masked and compared with
> +each value in the list. If a match is found, the cpu_features of cur_cpu_spec
> +is assigned to the feature bitmask for this processor and a __setup_cpu
> +function is called.
>  
>  C code may test 'cur_cpu_spec[smp_processor_id()]->cpu_features' for a
>  particular feature bit. This is done in quite a few places, for example
> @@ -51,6 +51,6 @@ should be used in the majority of cases.
>  
>  The END_FTR_SECTION macros are implemented by storing information about this
>  code in the '__ftr_fixup' ELF section. When do_cpu_ftr_fixups
> -(arch/ppc/kernel/misc.S) is invoked, it will iterate over the records in
> +(arch/powerpc/kernel/misc.S) is invoked, it will iterate over the records in
>  __ftr_fixup, and if the required feature is not present it will loop writing
>  nop's from each BEGIN_FTR_SECTION to END_FTR_SECTION.


