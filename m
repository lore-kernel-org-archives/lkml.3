Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab3KRCJ6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 21:09:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753101Ab3KRCJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 21:09:50 -0500
Date: Mon, 18 Nov 2013 10:08:51 +0800
From: Dave Young <dyoung@redhat.com>
To: Toshi Kani <toshi.kani@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de
Subject: Re: [patch 3/7 v2] Cleanup efi_enter_virtual_mode function
Message-ID: <20131118020850.GA4025@dhcp-16-126.nay.redhat.com>
References: <20131105082007.872550445@dhcp-16-126.nay.redhat.com>
 <20131105082716.825753041@dhcp-16-126.nay.redhat.com>
 <1384557682.1791.9.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384557682.1791.9.camel@misato.fc.hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/13 at 04:21pm, Toshi Kani wrote:
> On Tue, 2013-11-05 at 16:20 +0800, dyoung@redhat.com wrote:
> > Add two small functions:
> > efi_merge_regions and efi_map_regions, efi_enter_virtual_mode
> > calls them instead of embedding two long for loop.
> 
>  :
> 
> > +void __init efi_enter_virtual_mode(void)
> > +{
> > +	efi_status_t status;
> > +	void *p, *new_memmap = NULL;
> 
> *p is unused.

The *p was removed in later patch, will remove it in this patch.

Thanks for review.
Dave
