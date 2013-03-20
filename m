Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934324Ab3CTDWq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 23:22:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43092 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093Ab3CTDWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 23:22:44 -0400
Message-ID: <51492B78.7020404@zytor.com>
Date: Tue, 19 Mar 2013 20:22:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: Matthew Garrett <matthew.garrett@nebula.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 01/12] Security: Add CAP_COMPROMISE_KERNEL
References: <3pfl8u1ugprwkcs5xmtjth3l.1363742692541@email.android.com>  <51492379.3090302@zytor.com> <51492828.5070803@zytor.com> <1363749503.24132.482.camel@bling.home>
In-Reply-To: <1363749503.24132.482.camel@bling.home>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2013 08:18 PM, Alex Williamson wrote:
>>
>> The "pinning" process needs to involve a call to the kernel to process
>> the page for DMA (pinning the page and opening it in the iommu) and
>> return a transaction address, of course.
>>
>> I think we have the interface for that in vfio, but I haven't followed
>> that work.
> 
> Yes, vfio does this and is meant to provide a secure-boot-friendly PCI
> passthrough interface.  Thanks,
> 

Right, and presumably vfio does *not* require CAP_SYS_RAWIO, right?

	-hpa


