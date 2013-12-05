Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993Ab3LELv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 06:51:29 -0500
Received: from mail.skyhub.de ([78.46.96.112]:40187 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755492Ab3LELv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 06:51:27 -0500
Date: Thu, 5 Dec 2013 12:51:24 +0100
From: Borislav Petkov <bp@alien8.de>
To: Dave Young <dyoung@redhat.com>
Cc: Toshi Kani <toshi.kani@hp.com>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.infradead.org, greg@kroah.com, matt@console-pimps.org
Subject: Re: [PATCH v4 07/12] efi: passing kexec necessary efi data via
 setup_data
Message-ID: <20131205115124.GC14407@pd.tnic>
References: <1385445477-9665-8-git-send-email-dyoung@redhat.com>
 <20131127140732.GD32267@pd.tnic>
 <20131129091415.GH4186@dhcp-16-126.nay.redhat.com>
 <1386023600.1791.201.camel@misato.fc.hp.com>
 <1386034289.1791.210.camel@misato.fc.hp.com>
 <20131203015613.GB3980@dhcp-16-126.nay.redhat.com>
 <1386085140.1791.218.camel@misato.fc.hp.com>
 <20131204024610.GA3764@dhcp-16-126.nay.redhat.com>
 <1386175428.1791.225.camel@misato.fc.hp.com>
 <20131205015615.GC3736@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131205015615.GC3736@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 09:56:15AM +0800, Dave Young wrote:
> > The z420 firmware is based on some UEFI core that may be used by other
> > vendors as well.  Since this handling is totally harmless (just
> > redundant), I'd suggest not to have a platform check on this handling.
> 
> I have same worry as well, so I agree with you.

Btw, why does kexec need the ->smbios table at all? I see it being
passed in efi_setup_data.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
