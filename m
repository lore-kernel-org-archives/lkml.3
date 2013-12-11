Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027Ab3LKOFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 09:05:40 -0500
Received: from mail.skyhub.de ([78.46.96.112]:34340 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791Ab3LKOFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 09:05:39 -0500
Date: Wed, 11 Dec 2013 15:05:31 +0100
From: Borislav Petkov <bp@alien8.de>
To: Matt Fleming <matt@console-pimps.org>
Cc: Dave Young <dyoung@redhat.com>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.infradead.org, greg@kroah.com, toshi.kani@hp.com
Subject: Re: [PATCH v5 09/14] efi: passing kexec necessary efi data via
 setup_data
Message-ID: <20131211140531.GJ21683@pd.tnic>
References: <1386582147-9802-1-git-send-email-dyoung@redhat.com>
 <1386582147-9802-10-git-send-email-dyoung@redhat.com>
 <20131211121352.GB29980@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131211121352.GB29980@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 12:13:52PM +0000, Matt Fleming wrote:
> > +	for (i = 0, md = data->map; i < nr_efi_runtime_map; i++, md++) {
> > +		efi_map_region_fixed(md); /* FIXME: add error handling */
> 
> Oops. Please fix this ;-)

Yeah, this is on my TODO as it wraps around __map_region, the latter
needing to propagate error codes.

I'll take care of it once you merge Dave's patchset.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
