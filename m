Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbaFRO4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:56:23 -0400
Received: from mail-we0-f196.google.com ([74.125.82.196]:51664 "EHLO
	mail-we0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbaFRO4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:56:22 -0400
Date: Wed, 18 Jun 2014 15:56:19 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Daniel Kiper <daniel.kiper@oracle.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, andrew.cooper3@citrix.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        eshelton@pobox.com, hpa@zytor.com, ian.campbell@citrix.com,
        jbeulich@suse.com, jeremy@goop.org, konrad.wilk@oracle.com,
        matt.fleming@intel.com, mingo@redhat.com, mjg59@srcf.ucam.org,
        stefano.stabellini@eu.citrix.com, tglx@linutronix.de,
        Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH v5 1/7] efi: Use early_mem*() instead of early_io*()
Message-ID: <20140618145619.GP24049@console-pimps.org>
References: <1402678823-24589-1-git-send-email-daniel.kiper@oracle.com>
 <1402678823-24589-2-git-send-email-daniel.kiper@oracle.com>
 <20140618121709.GF24049@console-pimps.org>
 <20140618125957.GA28489@olila.local.net-space.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140618125957.GA28489@olila.local.net-space.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun, at 02:59:57PM, Daniel Kiper wrote:
> 
> I think that it improves readability a bit but if you wish I will not
> do that in the future.
 
That would be much appreciated.

> > As Matthew pointed out we may also need to access EFI mapped flash
> > devices.
> 
> Right, but I think it does not change a lot in that case. Flash
> is simply slower type of memory used as permanent storage.
> Am I missing something?
 
No you're not missing anything, I hit send too quickly while typing my
reply so the above isn't a complete thought. I don't think this
distinction between mapped flash and RAM matters in this case.

> As I saw David provided better explanation. If you wish I could include
> it in commit message.

Yeah, I think that would be very helpful, thanks!

-- 
Matt Fleming, Intel Open Source Technology Center
