Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663AbaDFXtD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 19:49:03 -0400
Received: from gate.crashing.org ([63.228.1.57]:59790 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754266AbaDFXtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 19:49:01 -0400
Message-ID: <1396828110.3671.21.camel@pasglop>
Subject: Re: [PATCH 1/2] fixup: "powerpc/perf: Add support for the hv 24x7
 interface"
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Michael Ellerman <michael@ellerman.id.au>,
        Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        cody+local@linux.vnet.ibm.com, LKML <linux-kernel@vger.kernel.org>,
        David.Laight@aculab.com, Anton Blanchard <anton@samba.org>
Date: Mon, 07 Apr 2014 09:48:30 +1000
In-Reply-To: <1396476654-20623-2-git-send-email-cody@linux.vnet.ibm.com>
References: <1396476654-20623-1-git-send-email-cody@linux.vnet.ibm.com>
	 <1396476654-20623-2-git-send-email-cody@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-02 at 15:10 -0700, Cody P Schafer wrote:
> Make the "not enabled" message less awful.
> 
> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
> ---
>  arch/powerpc/perf/hv-24x7.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/perf/hv-24x7.c b/arch/powerpc/perf/hv-24x7.c
> index 297c9105..3246ea2 100644
> --- a/arch/powerpc/perf/hv-24x7.c
> +++ b/arch/powerpc/perf/hv-24x7.c
> @@ -491,7 +491,7 @@ static int hv_24x7_init(void)
>  
>  	hret = hv_perf_caps_get(&caps);
>  	if (hret) {
> -		pr_info("could not obtain capabilities, error 0x%80lx, not enabling\n",
> +		pr_info("could not obtain capabilities, not enabling (%ld)\n",
>  				hret);

That's not much less awful... The message gives 0 informations about
where it comes from .. what is it that couldn't obtain capabilities ?

Also, sentences start with a Capital.

Cheers,
Ben.
 

