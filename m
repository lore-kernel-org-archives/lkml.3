Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab3KOX0J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 18:26:09 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:6690 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab3KOX0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 18:26:00 -0500
Message-ID: <1384557682.1791.9.camel@misato.fc.hp.com>
Subject: Re: [patch 3/7 v2] Cleanup efi_enter_virtual_mode function
From: Toshi Kani <toshi.kani@hp.com>
To: dyoung@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        bp@alien8.de
Date: Fri, 15 Nov 2013 16:21:22 -0700
In-Reply-To: <20131105082716.825753041@dhcp-16-126.nay.redhat.com>
References: <20131105082007.872550445@dhcp-16-126.nay.redhat.com>
	 <20131105082716.825753041@dhcp-16-126.nay.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-05 at 16:20 +0800, dyoung@redhat.com wrote:
> Add two small functions:
> efi_merge_regions and efi_map_regions, efi_enter_virtual_mode
> calls them instead of embedding two long for loop.

 :

> +void __init efi_enter_virtual_mode(void)
> +{
> +	efi_status_t status;
> +	void *p, *new_memmap = NULL;

*p is unused.


Thanks,
-Toshi

