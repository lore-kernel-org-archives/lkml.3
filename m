Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab3LLCMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 21:12:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24262 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708Ab3LLCMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 21:12:31 -0500
Date: Thu, 12 Dec 2013 10:11:45 +0800
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.infradead.org, greg@kroah.com, toshi.kani@hp.com
Subject: Re: [PATCH v5 09/14] efi: passing kexec necessary efi data via
 setup_data
Message-ID: <20131212021145.GD3751@dhcp-16-126.nay.redhat.com>
References: <1386582147-9802-1-git-send-email-dyoung@redhat.com>
 <1386582147-9802-10-git-send-email-dyoung@redhat.com>
 <20131211121352.GB29980@console-pimps.org>
 <20131211140531.GJ21683@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131211140531.GJ21683@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/13 at 03:05pm, Borislav Petkov wrote:
> On Wed, Dec 11, 2013 at 12:13:52PM +0000, Matt Fleming wrote:
> > > +	for (i = 0, md = data->map; i < nr_efi_runtime_map; i++, md++) {
> > > +		efi_map_region_fixed(md); /* FIXME: add error handling */
> > 
> > Oops. Please fix this ;-)
> 
> Yeah, this is on my TODO as it wraps around __map_region, the latter
> needing to propagate error codes.
> 
> I'll take care of it once you merge Dave's patchset.

Thanks Boris..
