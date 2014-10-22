Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbaJVN4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 09:56:53 -0400
Received: from mail-oi0-f52.google.com ([209.85.218.52]:36072 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbaJVN4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 09:56:51 -0400
MIME-Version: 1.0
X-Originating-IP: [2a01:e35:2434:4600:389c:cfae:9fd8:91b0]
In-Reply-To: <1413914126.4202.157.camel@ul30vt.home>
References: <1413205825-6370-1-git-send-email-a.motakis@virtualopensystems.com>
 <1413205825-6370-15-git-send-email-a.motakis@virtualopensystems.com> <1413914126.4202.157.camel@ul30vt.home>
From: Antonios Motakis <a.motakis@virtualopensystems.com>
Date: Wed, 22 Oct 2014 15:56:31 +0200
Message-ID: <CAG8rG2ztdXWJ=0D6i_PuqD6rrLWJe+P7FS2CS=i11D=u1hX6tQ@mail.gmail.com>
Subject: Re: [PATCH v8 14/18] vfio: move eventfd support code for VFIO_PCI to
 a separate file
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm-arm <kvmarm@lists.cs.columbia.edu>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Will Deacon <will.deacon@arm.com>,
        VirtualOpenSystems Technical Team <tech@virtualopensystems.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Eric Auger <eric.auger@linaro.org>,
        Kim Phillips <kim.phillips@freescale.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Alexander Gordeev <agordeev@redhat.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:VFIO DRIVER" <kvm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 7:55 PM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> On Mon, 2014-10-13 at 15:10 +0200, Antonios Motakis wrote:
>> The virqfd functionality that is used by VFIO_PCI to implement interrupt
>> masking and unmasking via an eventfd, is generic enough and can be reused
>> by another driver. Move it to a separate file in order to allow the code
>> to be shared.
>>
>> Also properly export virqfd_enable and virqfd_disable in the process.
>
> Let's be friendly to the global namespace and add vfio_ prefixes to
> these as we export them.
>

Ack.



-- 
Antonios Motakis
Virtual Open Systems
