Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab3KDJSK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 04:18:10 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:47066 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753174Ab3KDJSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 04:18:07 -0500
Date: Mon, 4 Nov 2013 09:18:00 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Dave Young <dyoung@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>, Linux EFI <linux-efi@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Vivek Goyal <vgoyal@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>
Subject: Re: [PATCH 10/11] EFI: Runtime services virtual mapping
Message-ID: <20131104091800.GB21688@console-pimps.org>
References: <1383236709-19716-1-git-send-email-bp@alien8.de>
 <1383236709-19716-11-git-send-email-bp@alien8.de>
 <20131101032551.GC4378@dhcp-16-126.nay.redhat.com>
 <20131103123115.GA5313@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131103123115.GA5313@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 03 Nov, at 08:31:15PM, Dave Young wrote:
> Hi, Matt
> 
> How should I handle this problem, would you take above commit or rebase efi
> next branch?

Dave, could you base your patches against the EFI 'master' branch? I've
rebased that branch on v3.12, which includes commit 700870119f49 ("x86,
efi: Don't map Boot Services on i386"), and merged everything from
'next'. Just note in the patch description which branch you've based
your work on and why in case I forget ;-)

Let me know if this causes any issues.

-- 
Matt Fleming, Intel Open Source Technology Center
