Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab3AKR2v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 12:28:51 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:16831 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323Ab3AKR2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 12:28:50 -0500
Date: Fri, 11 Jan 2013 12:28:44 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ethan Zhao <ethan.kernel@gmail.com>
Cc: Ryan Wilson <hap9@epoch.ncsc.mil>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch/x86/pci/xen.c: fix a typo in comments
Message-ID: <20130111172844.GA26287@phenom.dumpdata.com>
References: <CABawtvNHe7f9n+BAFfCzha2WNuovxNvfQabTyWFH_5oyfAh5Xg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABawtvNHe7f9n+BAFfCzha2WNuovxNvfQabTyWFH_5oyfAh5Xg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 09:22:11AM +0800, Ethan Zhao wrote:
> Konrad,
>       This patch fix a typo in comments of arch/x86/pci/xen.c

Hm, so somehow I don't see your SOB on the patch? Can you please
include that.
> 
> Thanks,
> Ethan.zhao@oracle.com
> 
> ---------------------------------------
> commit 333a48b76d5311ae370d65dfac293ca0d839c455
> Author: ethan.zhao <ethan.kernel@gmail.com>
> Date:   Thu Dec 20 20:23:31 2012 -0800
> 
>     Fix a typo in comments
> 
> diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
> index 56ab749..8de6ced 100644
> --- a/arch/x86/pci/xen.c
> +++ b/arch/x86/pci/xen.c
> @@ -2,7 +2,7 @@
>   * Xen PCI - handle PCI (INTx) and MSI infrastructure calls for PV, HVM and
>   * initial domain support. We also handle the DSDT _PRT callbacks for GSI's
>   * used in HVM and initial domain mode (PV does not parse ACPI, so it has
> no
> - * concept of GSIs). Under PV we hook under the pnbbios API for IRQs and
> + * concept of GSIs). Under PV we hook under the pnpbios API for IRQs and
>   * 0xcf8 PCI configuration read/write.
>   *
>   *   Author: Ryan Wilson <hap9@epoch.ncsc.mil>
