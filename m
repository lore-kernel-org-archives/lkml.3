Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932521AbaKMKTj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 05:19:39 -0500
Received: from smarthost01b.mail.zen.net.uk ([212.23.1.3]:36084 "EHLO
	smarthost01b.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932290AbaKMKTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 05:19:36 -0500
Message-ID: <1415873971.1725.2.camel@linaro.org>
Subject: Re: [PATCH 0/2] dma: pl330: Fixes for DMA memcpy
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Date: Thu, 13 Nov 2014 10:19:31 +0000
In-Reply-To: <20141112093158.GB24582@intel.com>
References: <1415383518-29327-1-git-send-email-tixy@linaro.org>
	 <20141112093158.GB24582@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01b-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-12 at 15:01 +0530, Vinod Koul wrote:
> On Fri, Nov 07, 2014 at 06:05:16PM +0000, Jon Medhurst wrote:
> > This is a couple of patches I produced when trying to get dmatest to run
> > with the pl330 driver. The second one is actually a theoretical fix
> > because the FIFO on the platform I was using is too large for the tests
> > to hit the limit, but the datasheet says the device can lockup if all
> > the FIFO entries are exhausted, so it seems like a sensible precaution.
> >
> Applied, thanks
>
> Please ensure you use the right subsystem name for the patch header

I originally created the patch when working on Linux 3.14 and most
previous updates to the file used 'dma', I see now in recent versions
that the preferred name is 'dmaengine' (and matches the mailing list
name) so will use that in future.

BTW, though I was working on 3.14 I have retested the patches on a
3.18-rc

-- 
Tixy


