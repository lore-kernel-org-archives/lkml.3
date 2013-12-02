Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab3LBCwf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 21:52:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828Ab3LBCw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 21:52:27 -0500
Date: Mon, 2 Dec 2013 10:51:41 +0800
From: Dave Young <dyoung@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.infradead.org, greg@kroah.com, toshi.kani@hp.com
Subject: Re: [PATCH v4 06/12] efi: export efi runtime memory mapping to sysfs
Message-ID: <20131202025141.GE3999@dhcp-16-126.nay.redhat.com>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
 <1385445477-9665-7-git-send-email-dyoung@redhat.com>
 <20131127114402.GB32267@pd.tnic>
 <20131129094034.GI4186@dhcp-16-126.nay.redhat.com>
 <20131129115029.GB4266@pd.tnic>
 <20131129115953.GD11775@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131129115953.GD11775@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/13 at 11:59am, Matt Fleming wrote:
> On Fri, 29 Nov, at 12:50:29PM, Borislav Petkov wrote:
> > > I did not add KEXEC because I thought it can be used for debugging
> > > purpose.
> > 
> > mfleming is thinking about it :)
>  
> I finally finished my thought. The sysfs code should be automatically
> enabled only if CONFIG_KEXEC is enabled, and not on my default because
> it is a debug interface. While it's true that the code may be useful for
> debugging the memory mappings of EFI systems, it doesn't make sense to
> always turn it on just for CONFIG_X86 and CONFIG_EFI.

Ok, will enable it only for CONFIG_X86 and CONFIG_EFI and CONFIG_KEXEC

> 
> -- 
> Matt Fleming, Intel Open Source Technology Center
