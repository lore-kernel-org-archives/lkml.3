Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751268Ab3KIFDF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 00:03:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40451 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000Ab3KIFDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 00:03:03 -0500
Message-ID: <527DC1BE.6030107@zytor.com>
Date: Fri, 08 Nov 2013 21:01:50 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Dave Young <dyoung@redhat.com>, Matt Fleming <matt@console-pimps.org>
CC: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.infradead.org, bp@alien8.de
Subject: Re: [patch 0/7 v2] kexec kernel efi runtime support
References: <20131105082007.872550445@dhcp-16-126.nay.redhat.com> <20131108143118.GA22636@console-pimps.org> <20131109035739.GB4294@dhcp-16-126.nay.redhat.com>
In-Reply-To: <20131109035739.GB4294@dhcp-16-126.nay.redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2013 07:57 PM, Dave Young wrote:
> 
> Hmm, if CONFIG_DEBUG_BOOT_PARAMS is not set, then kexec-tools should
> fail getting efi_info, so I will fix kexec-tools patch about this.
> 
> Also CONFIG_EFI_RUNTIME_MAP should select CONFIG_DEBUG_BOOT_PARAMS.
> In future will try to move the boot params data out of debugfs. 
> 

Honestly, if we need debugfs to get actual functionality, it shouldn't
be in sploit^Wdebugfs...

	-hpa


