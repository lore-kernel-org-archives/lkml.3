Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447AbaLEMW0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 07:22:26 -0500
Received: from 8bytes.org ([81.169.241.247]:55105 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbaLEMWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 07:22:24 -0500
Date: Fri, 5 Dec 2014 13:22:22 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Jiang Liu <jiang.liu@linux.intel.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [patch 0/5] x86/iommu: Bootup stage cleanups
Message-ID: <20141205122221.GL3762@8bytes.org>
References: <20141204234737.728961990@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141204234737.728961990@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Fri, Dec 05, 2014 at 08:48:28AM -0000, Thomas Gleixner wrote:
> That solves the issue at hand, but the iommu setup stays a tangled
> maze with completely non obvious setup mechanisms depending on the
> options (iommu on/off - irq remapping on/off).

Thanks for this nice cleanup, for the IOMMU parts you can add my

	Acked-by: Joerg Roedel <jroedel@suse.de>

This reminded me again how complicated the iommu-setup on x86 is, I will
look further in how this could be simplified.


	Joerg

