Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274Ab3A1OWZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 09:22:25 -0500
Received: from 8bytes.org ([85.214.48.195]:52789 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756756Ab3A1OWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 09:22:21 -0500
Date: Mon, 28 Jan 2013 15:22:17 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Cong Ding <dinggnu@gmail.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Tony Lindgren <tony@atomide.com>,
        Omar Ramirez Luna <omar.luna@linaro.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu: omap-iommu.c: remove unnecessary null pointer
 check
Message-ID: <20130128142217.GX25591@8bytes.org>
References: <1358541741-20708-1-git-send-email-dinggnu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358541741-20708-1-git-send-email-dinggnu@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon Jan 28 15:22:18 2013
X-DSPAM-Confidence: 0.9993
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5106899a22974290014791
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 09:42:18PM +0100, Cong Ding wrote:
> Signed-off-by: Cong Ding <dinggnu@gmail.com>
> ---
>  drivers/iommu/omap-iommu.c |    4 ++--

Applied to arm/omap, thanks.


