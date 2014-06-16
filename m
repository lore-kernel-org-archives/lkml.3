Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718AbaFPTHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 15:07:10 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:44630 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755493AbaFPTHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 15:07:08 -0400
Date: Mon, 16 Jun 2014 21:06:23 +0200
From: Daniel Kiper <daniel.kiper@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, andrew.cooper3@citrix.com,
        boris.ostrovsky@oracle.com, eshelton@pobox.com, hpa@zytor.com,
        ian.campbell@citrix.com, jbeulich@suse.com, jeremy@goop.org,
        konrad.wilk@oracle.com, matt.fleming@intel.com, mingo@redhat.com,
        mjg59@srcf.ucam.org, stefano.stabellini@eu.citrix.com,
        tglx@linutronix.de
Subject: Re: [PATCH v5 4/7] xen: Put EFI machinery in place
Message-ID: <20140616190623.GI3463@olila.local.net-space.pl>
References: <1402678823-24589-1-git-send-email-daniel.kiper@oracle.com>
 <1402678823-24589-5-git-send-email-daniel.kiper@oracle.com>
 <539EDC5D.4010207@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <539EDC5D.4010207@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 01:00:29PM +0100, David Vrabel wrote:
> On 13/06/14 18:00, Daniel Kiper wrote:
> >
> > v5 - suggestions/fixes:
>
> Put after a --- marker.

Why?

You mean:

---

v5 - suggestions/fixes:
...

> > +static efi_char16_t vendor[100] __initdata;
>
> Why 100?

Well... Quite arbitrary value. The same thing is used in
arch/x86/platform/efi/efi.c:efi_init(). Sadly UEFI sepec
says nothing about maximum vendor name length.

Daniel
