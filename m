Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607Ab3KYVXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 16:23:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46011 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473Ab3KYVXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 16:23:38 -0500
Message-ID: <5293BF8B.20203@zytor.com>
Date: Mon, 25 Nov 2013 13:22:19 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: dyoung@redhat.com, linux-kernel@vger.kernel.org
CC: linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de, greg@kroah.com, matt@console-pimps.org,
        toshi.kani@hp.com
Subject: Re: [patch 00/12 v4] kexec kernel efi runtime support v	v4] efi:
 export more efi table variable to sysfs
References: <20131125085630.417850406@dhcp-16-126.nay.redhat.com>
In-Reply-To: <20131125085630.417850406@dhcp-16-126.nay.redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2013 12:56 AM, dyoung@redhat.com wrote:
> 
> For efi runtime mapping I add a new directory /sys/firmware/efi/
> runtime-map/ like below
> [dave@darkstar ~]$ tree /sys/firmware/efi/runtime-map/
> /sys/firmware/efi/runtime-map/
> â”œâ”€â”€ 0
> â”‚   â”œâ”€â”€ attribute
> â”‚   â”œâ”€â”€ num_pages
> â”‚   â”œâ”€â”€ phys_addr
> â”‚   â”œâ”€â”€ type
> â”‚   â””â”€â”€ virt_addr
> â”œâ”€â”€ 1
> â”‚   â”œâ”€â”€ attribute
> â”‚   â”œâ”€â”€ num_pages
> â”‚   â”œâ”€â”€ phys_addr
> â”‚   â”œâ”€â”€ type
> â”‚   â””â”€â”€ virt_addr
> [snip]
>  

These patches came through severely corrupted, the above is typical...
	
	-hpa


