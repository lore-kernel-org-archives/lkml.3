Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449Ab3LMLVm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 06:21:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846Ab3LMLVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 06:21:40 -0500
Date: Fri, 13 Dec 2013 15:27:42 +0800
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        greg@kroah.com, matt@console-pimps.org, toshi.kani@hp.com
Subject: Re: [PATCH v5 09/14] efi: passing kexec necessary efi data via
 setup_data
Message-ID: <20131213072742.GC11164@dhcp-16-126.nay.redhat.com>
References: <1386582147-9802-1-git-send-email-dyoung@redhat.com>
 <1386582147-9802-10-git-send-email-dyoung@redhat.com>
 <20131211222057.GB8863@pd.tnic>
 <20131212030619.GG3751@dhcp-16-126.nay.redhat.com>
 <20131212071743.GJ3751@dhcp-16-126.nay.redhat.com>
 <20131212210439.GB30162@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131212210439.GB30162@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/13 at 10:04pm, Borislav Petkov wrote:
> On Thu, Dec 12, 2013 at 03:17:43PM +0800, Dave Young wrote:
> > Rethink about this issue, moving them to efi_$(BITS).c I need move the
> > efi_setup from a static variable to an extern, It looks not worth.
> 
> Dave, would you please do what is suggested to you? A big part of
> the efi code is split into 32-bit and 64-bit functionality. If you
> have a serious argument why it shouldn't be done so then sure, by all
> means, but stop coming up with silly arguments like having an extern
> declaration is a bad thing. Please.

Ok, will do.

--
Thanks
Dave
