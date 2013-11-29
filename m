Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700Ab3K2Ipg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 03:45:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528Ab3K2Ipc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 03:45:32 -0500
Date: Fri, 29 Nov 2013 16:44:14 +0800
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        greg@kroah.com, matt@console-pimps.org, toshi.kani@hp.com
Subject: Re: [PATCH v4 09/12] x86: add xloadflags bit for efi runtime support
 on kexec
Message-ID: <20131129084414.GD4186@dhcp-16-126.nay.redhat.com>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
 <1385445477-9665-10-git-send-email-dyoung@redhat.com>
 <20131127142732.GF32267@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131127142732.GF32267@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/13 at 03:27pm, Borislav Petkov wrote:
> On Tue, Nov 26, 2013 at 01:57:54PM +0800, Dave Young wrote:
> > Old kexec-tools can not load new kernel. The reason is previously kexec-tools
> 
> The reason is, kexec-tools ... previously, thus efi failed to initialize ...

Good suggestion

> 
> > do not fill efi_info in x86 setup header thus efi init fail and switch
> > to noefi boot. In new kexec-tools it will by default fill efi_info and
> > pass other efi required infomation to 2nd kernel so kexec kernel efi
> > initialization will success finally.
> 
> 		      succeed

Will fix

> 
> > 
> > To prevent from breaking userspace, add a new xloadflags bit so kexec-tools
> > will check the flag and switch to old logic.
> > 
> > changelog:
> > Matt: +&& defined(CONFIG_KEXEC)
> > HPA: document the flag.
> > 
> > Signed-off-by: Dave Young <dyoung@redhat.com>
> 
> Other than that:
> 
> Acked-by: Borislav Petkov <bp@suse.de>
> 

Thanks
Dave
