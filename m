Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933688AbaJURzv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 13:55:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40703 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933430AbaJURzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 13:55:49 -0400
Message-ID: <1413914126.4202.157.camel@ul30vt.home>
Subject: Re: [PATCH v8 14/18] vfio: move eventfd support code for VFIO_PCI
 to a separate file
From: Alex Williamson <alex.williamson@redhat.com>
To: Antonios Motakis <a.motakis@virtualopensystems.com>
Cc: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        will.deacon@arm.com, tech@virtualopensystems.com,
        christoffer.dall@linaro.org, eric.auger@linaro.org,
        kim.phillips@freescale.com, marc.zyngier@arm.com,
        Bjorn Helgaas <bhelgaas@google.com>,
        Alexander Gordeev <agordeev@redhat.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:VFIO DRIVER" <kvm@vger.kernel.org>
Date: Tue, 21 Oct 2014 11:55:26 -0600
In-Reply-To: <1413205825-6370-15-git-send-email-a.motakis@virtualopensystems.com>
References: <1413205825-6370-1-git-send-email-a.motakis@virtualopensystems.com>
	 <1413205825-6370-15-git-send-email-a.motakis@virtualopensystems.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-13 at 15:10 +0200, Antonios Motakis wrote:
> The virqfd functionality that is used by VFIO_PCI to implement interrupt
> masking and unmasking via an eventfd, is generic enough and can be reused
> by another driver. Move it to a separate file in order to allow the code
> to be shared.
> 
> Also properly export virqfd_enable and virqfd_disable in the process.

Let's be friendly to the global namespace and add vfio_ prefixes to
these as we export them.

