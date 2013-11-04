Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027Ab3KDImr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 03:42:47 -0500
Received: from mga01.intel.com ([192.55.52.88]:25404 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570Ab3KDImq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 03:42:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,630,1378882800"; 
   d="scan'208";a="421856414"
Date: Mon, 4 Nov 2013 09:42:44 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com
Subject: Re: [PATCH] mfd: max77693: Fix up bug of wrong interrupt number
Message-ID: <20131104084244.GD6566@zurbaran>
References: <1381367155-4888-1-git-send-email-cw00.choi@samsung.com>
 <5276FF3C.9050304@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5276FF3C.9050304@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On Mon, Nov 04, 2013 at 10:58:20AM +0900, Chanwoo Choi wrote:
> Ping!
> 
> Thanks,
> Chanwoo Choi
> 
> On 10/10/2013 10:05 AM, Chanwoo Choi wrote:
> > The max77693 MFD device use irq domain method which has hardware interrupt number
> > and virtual interrupt number getting through irq domain mapping. This patch
> > use hardware interrupt number instead of virtual interrupt number to get
> > struct irq_data.
> > 
> > Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  drivers/mfd/max77693-irq.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
