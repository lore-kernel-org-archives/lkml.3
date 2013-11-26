Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab3KZBgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 20:36:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088Ab3KZBgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 20:36:19 -0500
Date: Tue, 26 Nov 2013 09:35:20 +0800
From: Dave Young <dyoung@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.infradead.org, bp@alien8.de, greg@kroah.com,
        matt@console-pimps.org, toshi.kani@hp.com
Subject: Re: [patch 00/12 v4] kexec kernel efi runtime support v	v4]
 efi: export more efi table variable to sysfs
Message-ID: <20131126013520.GA3706@dhcp-16-126.nay.redhat.com>
References: <20131125085630.417850406@dhcp-16-126.nay.redhat.com>
 <5293BF8B.20203@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5293BF8B.20203@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/13 at 01:22pm, H. Peter Anvin wrote:
> On 11/25/2013 12:56 AM, dyoung@redhat.com wrote:
> > 
> > For efi runtime mapping I add a new directory /sys/firmware/efi/
> > runtime-map/ like below
> > [dave@darkstar ~]$ tree /sys/firmware/efi/runtime-map/
> > /sys/firmware/efi/runtime-map/
> > â”œâ”€â”€ 0
> > â”‚   â”œâ”€â”€ attribute
> > â”‚   â”œâ”€â”€ num_pages
> > â”‚   â”œâ”€â”€ phys_addr
> > â”‚   â”œâ”€â”€ type
> > â”‚   â””â”€â”€ virt_addr
> > â”œâ”€â”€ 1
> > â”‚   â”œâ”€â”€ attribute
> > â”‚   â”œâ”€â”€ num_pages
> > â”‚   â”œâ”€â”€ phys_addr
> > â”‚   â”œâ”€â”€ type
> > â”‚   â””â”€â”€ virt_addr
> > [snip]
> >  
> 
> These patches came through severely corrupted, the above is typical...

Hi, Peter

Will resend them today again.

--
Thanks
Dave
