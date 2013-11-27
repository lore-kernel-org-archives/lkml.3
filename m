Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab3K0IS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 03:18:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012Ab3K0ISx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 03:18:53 -0500
Date: Wed, 27 Nov 2013 16:17:53 +0800
From: Dave Young <dyoung@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de, greg@kroah.com, toshi.kani@hp.com
Subject: Re: [PATCH v4 06/12] efi: export efi runtime memory mapping to sysfs
Message-ID: <20131127081753.GA19809@dhcp-16-126.nay.redhat.com>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
 <1385445477-9665-7-git-send-email-dyoung@redhat.com>
 <20131126193016.GA18170@console-pimps.org>
 <20131127030706.GB11852@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131127030706.GB11852@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/13 at 11:07am, Dave Young wrote:
> > > It will not work for efi 32bit. Only x86_64 currently.
> >  
> > Actually, exporting the tables does work for 32-bit, right? It's just
> > that kexec doesn't work for 32-bit EFI?
> 
> It does not make sense to export them for 32-bit because we do not
> support kexec efi on 32-bit. Will change the description to below:
> 
> "kexec efi boot on 32-bit is not supported so I only export the tables
> for 64-bit efi system."

I thought about only enabling it for x86_64 and efi is in .config.
Rethinking about this, since exporting code will also work for 32-bit so I
will remove the lines you mentioned.

Thanks
Dave
