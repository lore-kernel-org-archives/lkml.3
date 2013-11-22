Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab3KVCzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 21:55:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587Ab3KVCzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 21:55:51 -0500
Date: Fri, 22 Nov 2013 10:54:56 +0800
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        greg@kroah.com, matt@console-pimps.org, toshi.kani@hp.com
Subject: Re: [patch 4/9 v3] efi: cleanup efi_enter_virtual_mode function
Message-ID: <20131122025456.GE3874@dhcp-16-126.nay.redhat.com>
References: <20131121061704.363730447@dhcp-16-126.nay.redhat.com>
 <20131121061754.304016344@dhcp-16-126.nay.redhat.com>
 <20131121164929.GM26009@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131121164929.GM26009@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +
> > +/*
> > + * Map efi memory ranges for runtime serivce and
> > + * update new_memmap with virtual addresses.
> > + */
> 
> Stretch comment to 80 cols:
> 
> /*
>  * Map efi memory ranges for runtime serivce and update new_memmap with virtual
>  * addresses.
>  */
> 
> like it is customary for the rest of the file.

Ok, will do.

--
Thanks for review
Dave
