Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822Ab3C2Ogg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 10:36:36 -0400
Received: from mail-qe0-f46.google.com ([209.85.128.46]:62889 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab3C2Oge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 10:36:34 -0400
MIME-Version: 1.0
X-Originating-IP: [72.73.18.11]
In-Reply-To: <CAJtEV7bvPORPoXgQY2OahNVMj+SY5z=xxQ=nueX7=kLVfpyF_A@mail.gmail.com>
References: <1354533387-4110-1-git-send-email-acooks@gmail.com>
	<1355914703-28576-1-git-send-email-acooks@gmail.com>
	<1362126373-32318-1-git-send-email-acooks@gmail.com>
	<CAO9zADxjoP+R9ccz7vMPmcFvdYwNjErSjaWc_RFkW_FY3+SK=w@mail.gmail.com>
	<CAJtEV7Zs2BiwJ9jdDeoceh9hiVXvVaSvj=9H+4+vEzhY72AS9g@mail.gmail.com>
	<00b701ce16d3$0aabe0f0$2003a2d0$@lucidpixels.com>
	<CAJtEV7bvPORPoXgQY2OahNVMj+SY5z=xxQ=nueX7=kLVfpyF_A@mail.gmail.com>
Date: Fri, 29 Mar 2013 10:36:33 -0400
Message-ID: <CAO9zADxcQrUBYsOZST7C0RmMuWEPZjsqroM_LL82sGbt4+qZWA@mail.gmail.com>
Subject: Re: [PATCH] Quirk to support Marvell 88SE91xx SATA controllers with
 Intel IOMMU.
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Andrew Cooks <acooks@gmail.com>
Cc: Joerg Roedel <joro@8bytes.org>, YingChu <xjtuychu@hotmail.com>,
        Chu Ying <gm.ychu@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:PCI SUBSYSTEM" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 3, 2013 at 8:35 PM, Andrew Cooks <acooks@gmail.com> wrote:
> On Sat, Mar 2, 2013 at 7:18 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>>
>> Against a clean 3.7.10 (from ftp.kernel.org)
>>
>> # patch -p1 <
>> ../patch/RFC-Fix-Intel-IOMMU-support-for-Marvell-88SE91xx-SATA-controllers..
>> patch
>> patching file drivers/iommu/intel-iommu.c
>> patching file drivers/pci/quirks.c
>> Hunk #1 succeeded at 3230 (offset 3 lines).
>> patching file include/linux/pci.h
>> # pwd
>> /usr/src/linux-3.7.10
>>
>
> I've downloaded and patched the 3.7.10 tarball and still get the same
> output I got before; different output from yours. I'm not sure the
> patch is complete or applying correctly, are you?
> Could you please check whether the patch you're applying is the same

Hi,

As this patch is now working for some time (against 3.7.x), I was
wondering when it was going to be included in mainline?

I had upgraded to 3.8.x and rebooted and the same problem recurred and
had to revert back to 3.7.x.

Thanks,

Justin.
