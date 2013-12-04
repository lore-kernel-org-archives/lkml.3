Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab3LDCrH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 21:47:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764Ab3LDCrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 21:47:04 -0500
Date: Wed, 4 Dec 2013 10:46:10 +0800
From: Dave Young <dyoung@redhat.com>
To: Toshi Kani <toshi.kani@hp.com>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.infradead.org, greg@kroah.com, matt@console-pimps.org
Subject: Re: [PATCH v4 07/12] efi: passing kexec necessary efi data via
 setup_data
Message-ID: <20131204024610.GA3764@dhcp-16-126.nay.redhat.com>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
 <1385445477-9665-8-git-send-email-dyoung@redhat.com>
 <20131127140732.GD32267@pd.tnic>
 <20131129091415.GH4186@dhcp-16-126.nay.redhat.com>
 <1386023600.1791.201.camel@misato.fc.hp.com>
 <1386034289.1791.210.camel@misato.fc.hp.com>
 <20131203015613.GB3980@dhcp-16-126.nay.redhat.com>
 <1386085140.1791.218.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386085140.1791.218.camel@misato.fc.hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Toshi

> Oh, I think I now understand what the issue was.  The z420 firmware
> updates the SMBIOS table address in the EFI system table to a virtual
> address after calling EFI SetVirtualAddressMap.  So, you are passing the
> original physical address of the SMBIOS table from the 1st kernel to the
> 2nd kernel to put it back to physical.  Is that right? 

Right.

Thanks
Dave
