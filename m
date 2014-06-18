Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbaFRODm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:03:42 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:27922 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbaFRODl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:03:41 -0400
Date: Wed, 18 Jun 2014 10:01:01 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Daniel Kiper <daniel.kiper@oracle.com>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, andrew.cooper3@citrix.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        eshelton@pobox.com, hpa@zytor.com, ian.campbell@citrix.com,
        jbeulich@suse.com, jeremy@goop.org, matt.fleming@intel.com,
        mingo@redhat.com, mjg59@srcf.ucam.org,
        stefano.stabellini@eu.citrix.com, tglx@linutronix.de
Subject: Re: [PATCH v5 6/7] arch/x86: Remove redundant set_bit() call
Message-ID: <20140618140101.GC4651@laptop.dumpdata.com>
References: <1402678823-24589-1-git-send-email-daniel.kiper@oracle.com>
 <1402678823-24589-7-git-send-email-daniel.kiper@oracle.com>
 <20140618135637.GJ24049@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140618135637.GJ24049@console-pimps.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 02:56:37PM +0100, Matt Fleming wrote:
> On Fri, 13 Jun, at 07:00:22PM, Daniel Kiper wrote:
> > Remove redundant set_bit(EFI_SYSTEM_TABLES, &efi.flags) call.
> > It is executed earlier in efi_systab_init().
> > 
> > Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
> > ---
> >  arch/x86/platform/efi/efi.c |    2 --
> >  1 file changed, 2 deletions(-)
> 
> Looks good!

Is that an Acked-by or Reviewed-by ? :-)
> 
> -- 
> Matt Fleming, Intel Open Source Technology Center
