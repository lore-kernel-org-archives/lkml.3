Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156Ab3CIFHV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 00:07:21 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:53323 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab3CIFHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 00:07:17 -0500
MIME-Version: 1.0
In-Reply-To: <87ip5286cv.fsf@meteor.durcheinandertal.bofh>
References: <1362710133-25168-1-git-send-email-acooks@gmail.com>
	<87ip5286cv.fsf@meteor.durcheinandertal.bofh>
Date: Sat, 9 Mar 2013 13:07:15 +0800
Message-ID: <CAJtEV7ZKZkVbNCL95-eVvvHt0C6bS-hJTi_OJwBtadineeOR3Q@mail.gmail.com>
Subject: Re: [PATCH v4] Quirk for buggy dma source tags with Intel IOMMU.
From: Andrew Cooks <acooks@gmail.com>
To: Gaudenz Steinlin <gaudenz@soziologie.ch>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        Justin Piszcz <jpiszcz@lucidpixels.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:PCI SUBSYSTEM" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 8, 2013 at 7:43 PM, Gaudenz Steinlin <gaudenz@soziologie.ch> wrote:
>
> Hi Andrew
>
> Andrew Cooks <acooks@gmail.com> writes:
>
>> This patch creates a quirk to allow the Intel IOMMU to be enabled for devices
>> that use incorrect tags during DMA. It is similar to the quirk for Ricoh
>> devices, but allows mapping multiple functions and mapping of 'ghost'
>> functions that do not correspond to real devices. Devices that need this
>> include a variety of Marvell 88SE91xx based SATA controllers. [1][2]
>
> I can confirm that this version of the patch also works for my mini-PCIe
> device (88NV9143). See the my mail about it for more information. I had
> to manually fix the patch because the patch utility did not understand
> it. There is a formatting error in the last hunk for quirks.c (missing
> space before context line) and the line count in the hunk header is
> wrong (66 lines changed should be 56 lines). I hope nothing was missing
> from the patch.
>
> Tested on 3.8.2.

Thanks for testing.

The formatting error is embarrassing. I was impatient and removed some
unused content from the patch, instead of cleaning the source. The
thing about posting to open lists with thousands or subscribers and
searchable archives is that it's impossible to hide incompetence.

a.
