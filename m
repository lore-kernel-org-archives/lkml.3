Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094AbaGGOu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 10:50:27 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:41880 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbaGGOuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 10:50:24 -0400
Date: Mon, 7 Jul 2014 15:50:16 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Tony Luck <tony.luck@gmail.com>
Cc: linux-efi@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, andrew.cooper3@citrix.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        eshelton@pobox.com, fenghua.yu@intel.com, hpa@zytor.com,
        ian.campbell@citrix.com, jbeulich@suse.com, jeremy@goop.org,
        konrad.wilk@oracle.com, matt.fleming@intel.com, mingo@redhat.com,
        mjg59@srcf.ucam.org, stefano.stabellini@eu.citrix.com,
        tglx@linutronix.de, Daniel Kiper <daniel.kiper@oracle.com>,
        tony.luck@intel.com
Subject: Re: [PATCH v7 01/10] arch/ia64: Define early_memunmap()
Message-ID: <20140707145016.GB2914@console-pimps.org>
References: <1404150784-27921-1-git-send-email-daniel.kiper@oracle.com>
 <1404150784-27921-2-git-send-email-daniel.kiper@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404150784-27921-2-git-send-email-daniel.kiper@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun, at 07:52:55PM, Daniel Kiper wrote:
> This is odd to use early_iounmap() function do tear down mapping
> created by early_memremap() function, even if it works right now,
> because they belong to different set of functions. The former is
> I/O related function and the later is memory related. So, create
> early_memunmap() macro which in real is early_iounmap(). This
> thing will help to not confuse code readers longer by mixing
> functions from different classes.
> 
> EFI patches following this patch uses that functionality.
> 
> Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
> ---
>  arch/ia64/include/asm/io.h |    1 +
>  1 file changed, 1 insertion(+)

Tony, this looks pretty straight forward but I'd be much obliged if you
could give me an Acked-by.

-- 
Matt Fleming, Intel Open Source Technology Center
