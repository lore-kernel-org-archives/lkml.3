Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648AbaJAMuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 08:50:21 -0400
Received: from www.linutronix.de ([62.245.132.108]:37487 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbaJAMuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 08:50:19 -0400
Date: Wed, 1 Oct 2014 14:49:53 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Borislav Petkov <bp@alien8.de>
cc: x86-ml <x86@kernel.org>, bhelgaas@google.com, linux-pci@vger.kernel.org,
        hpa@zytor.com, bp@suse.de, dan.carpenter@oracle.com,
        dougthompson@xmission.com, m.chehab@samsung.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Subject: Re: [PATCH 2/4] x86, amd_nb: Add device IDs to NB tables for F15h
 M60h
In-Reply-To: <20141001113245.GD18271@pd.tnic>
Message-ID: <alpine.DEB.2.11.1410011449400.5001@nanos>
References: <1411070205-10217-1-git-send-email-Aravind.Gopalakrishnan@amd.com> <20141001113245.GD18271@pd.tnic>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 1 Oct 2014, Borislav Petkov wrote:

> tip guys,
> 
> can I get an ACK for this one so that I can route it through the EDAC
> tree for 3.19?

Acked-by: Thomas Gleixner <tglx@linutronix.de>

 
> Thanks.
> 
> On Thu, Sep 18, 2014 at 02:56:45PM -0500, Aravind Gopalakrishnan wrote:
> > Add F3 and F4 PCI device IDs to amd_nb_misc_ids[] and
> > amd_nb_link_ids[] respectively. We need this to cache the
> > Northbridges.
> > 
> > Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
> > ---
> >  arch/x86/kernel/amd_nb.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
> > index f04dbb3..5caed1d 100644
> > --- a/arch/x86/kernel/amd_nb.c
> > +++ b/arch/x86/kernel/amd_nb.c
> > @@ -21,6 +21,7 @@ const struct pci_device_id amd_nb_misc_ids[] = {
> >  	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F3) },
> >  	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_M10H_F3) },
> >  	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_M30H_NB_F3) },
> > +	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_M60H_NB_F3) },
> >  	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_16H_NB_F3) },
> >  	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_16H_M30H_NB_F3) },
> >  	{}
> > @@ -30,6 +31,7 @@ EXPORT_SYMBOL(amd_nb_misc_ids);
> >  static const struct pci_device_id amd_nb_link_ids[] = {
> >  	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F4) },
> >  	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_M30H_NB_F4) },
> > +	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_M60H_NB_F4) },
> >  	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_16H_NB_F4) },
> >  	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_16H_M30H_NB_F4) },
> >  	{}
> > -- 
> > 2.0.2
> > 
> > 
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --
> 
