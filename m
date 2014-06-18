Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751119AbaFROsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:48:38 -0400
Received: from mail-wg0-f67.google.com ([74.125.82.67]:63028 "EHLO
	mail-wg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaFROsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:48:36 -0400
Date: Wed, 18 Jun 2014 15:48:33 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        Daniel Kiper <daniel.kiper@oracle.com>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, andrew.cooper3@citrix.com,
        eshelton@pobox.com, hpa@zytor.com, ian.campbell@citrix.com,
        jbeulich@suse.com, jeremy@goop.org, matt.fleming@intel.com,
        mingo@redhat.com, mjg59@srcf.ucam.org,
        stefano.stabellini@eu.citrix.com, tglx@linutronix.de
Subject: Re: [PATCH v5 0/7] xen: Add EFI support
Message-ID: <20140618144833.GO24049@console-pimps.org>
References: <1402678823-24589-1-git-send-email-daniel.kiper@oracle.com>
 <20140618141541.GM24049@console-pimps.org>
 <20140618143143.GB8545@laptop.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140618143143.GB8545@laptop.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun, at 10:31:43AM, Konrad Rzeszutek Wilk wrote:
> 
> Your tree is perfect. I presume you do some automatic regression testing
> when you have accumulated a tons of patch - so if any of them cause havoc
> we can catch them before the merge window and fix them.
 
Yeah, I run regression tests to catch breakage to EFI platforms, usually
as soon as I apply them.

> Nah, lets do your tree. And either Boris, me or David will supply
> the Acked-by on the drivers/xen* and arch/x86/xen/* so all the
> right tags are in place.
 
Sounds like a plan.

> Thanks again!

My pleasure.

-- 
Matt Fleming, Intel Open Source Technology Center
