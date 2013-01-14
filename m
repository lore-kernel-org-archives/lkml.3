Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802Ab3ANNmu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 08:42:50 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38371 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755426Ab3ANNmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 08:42:49 -0500
Date: Mon, 14 Jan 2013 22:42:36 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: sameo@linux.intel.com, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        rob@landley.net, lrg@ti.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] mfd: tps65090: remove suspend/resume callbacks
Message-ID: <20130114134235.GD25037@opensource.wolfsonmicro.com>
References: <1356686981-4152-1-git-send-email-ldewangan@nvidia.com>
 <1356686981-4152-5-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356686981-4152-5-git-send-email-ldewangan@nvidia.com>
X-Cookie: You will inherit millions of dollars.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 02:59:41PM +0530, Laxman Dewangan wrote:
> The tps65090 mfd driver implement the suspend/resume callbacks
> which just disable and enable irqs in suspend/resume respectively.
> 
> This operation is already done in irq suspend and irq_resume and
> hence it is not require to implement the same in the driver.
> 
> Remove this non-require code.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
