Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbaGANZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 09:25:55 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:43408 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbaGANZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 09:25:53 -0400
Date: Tue, 1 Jul 2014 15:24:57 +0200
From: Daniel Kiper <daniel.kiper@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: linux-efi@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, andrew.cooper3@citrix.com,
        boris.ostrovsky@oracle.com, eshelton@pobox.com, fenghua.yu@intel.com,
        hpa@zytor.com, ian.campbell@citrix.com, jbeulich@suse.com,
        jeremy@goop.org, konrad.wilk@oracle.com, matt.fleming@intel.com,
        mingo@redhat.com, mjg59@srcf.ucam.org,
        stefano.stabellini@eu.citrix.com, tglx@linutronix.de,
        tony.luck@intel.com
Subject: Re: [PATCH v7 00/10] xen: Add EFI support
Message-ID: <20140701132457.GQ14729@olila.local.net-space.pl>
References: <1404150784-27921-1-git-send-email-daniel.kiper@oracle.com>
 <53B2B3E6.1080203@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B2B3E6.1080203@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 02:13:10PM +0100, David Vrabel wrote:
> On 30/06/14 18:52, Daniel Kiper wrote:
> > Hey,
> >
> > This patch series adds EFI support for Xen dom0 guests.
> > It is based on Jan Beulich and Tang Liang work. I was
> > trying to take into account all previous comments,
> > however, if I missed something sorry for that.
>
> What's changed in this version?

I have added "arch/ia64: Define early_memunmap()" patch, moved
xen_efi_probe() declaration to include/xen/xen-ops.h as Stefano
asked, added yours Reviewed-by to Xen stuff and did more tests.

Daniel
