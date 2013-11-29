Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab3K2MAL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 07:00:11 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:39663 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752755Ab3K2MAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 07:00:09 -0500
Date: Fri, 29 Nov 2013 11:59:53 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Dave Young <dyoung@redhat.com>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.infradead.org, greg@kroah.com, toshi.kani@hp.com
Subject: Re: [PATCH v4 06/12] efi: export efi runtime memory mapping to sysfs
Message-ID: <20131129115953.GD11775@console-pimps.org>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
 <1385445477-9665-7-git-send-email-dyoung@redhat.com>
 <20131127114402.GB32267@pd.tnic>
 <20131129094034.GI4186@dhcp-16-126.nay.redhat.com>
 <20131129115029.GB4266@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131129115029.GB4266@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Nov, at 12:50:29PM, Borislav Petkov wrote:
> > I did not add KEXEC because I thought it can be used for debugging
> > purpose.
> 
> mfleming is thinking about it :)
 
I finally finished my thought. The sysfs code should be automatically
enabled only if CONFIG_KEXEC is enabled, and not on my default because
it is a debug interface. While it's true that the code may be useful for
debugging the memory mappings of EFI systems, it doesn't make sense to
always turn it on just for CONFIG_X86 and CONFIG_EFI.

-- 
Matt Fleming, Intel Open Source Technology Center
