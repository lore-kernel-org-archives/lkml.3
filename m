Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897AbaK1O5f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 09:57:35 -0500
Received: from mga01.intel.com ([192.55.52.88]:57211 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444AbaK1O5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 09:57:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,477,1413270000"; 
   d="scan'208";a="639590609"
Date: Fri, 28 Nov 2014 16:57:04 +0200
From: Laurentiu Palcu <laurentiu.palcu@intel.com>
To: Mark Brown <broonie@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Johan Havold <johan@kernel.org>,
        Octavian Purdila <octavian.purdila@intel.com>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 1/2] spi: add support for DLN-2 USB-SPI adapter
Message-ID: <20141128145703.GA16201@lpalcu-linux>
References: <1416312599-5176-2-git-send-email-laurentiu.palcu@intel.com>
 <1417180198-9393-1-git-send-email-laurentiu.palcu@intel.com>
 <20141128141053.GL7712@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141128141053.GL7712@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, Nov 28, 2014 at 02:10:53PM +0000, Mark Brown wrote:
> On Fri, Nov 28, 2014 at 03:09:58PM +0200, Laurentiu Palcu wrote:
> > This adds support for Diolan DLN2 USB-SPI adapter.
> 
> I'm missing patch 2 of this series and the cover letter, are there any
> dependencies.

The other patch in this series was already applied by Lee on
for-mfd-next branch:
http://git.kernel.org/cgit/linux/kernel/git/lee/mfd.git/commit/?h=for-mfd-next&id=21cf3318d675b6ceeb5a3ed82ffe467a2b6eaee4

The original dependency, 3 patches that implement the DLN2 mfd driver
and the I2C/GPIO module drivers, is also in for-mfd-next:
http://git.kernel.org/cgit/linux/kernel/git/lee/mfd.git/commit/?h=for-mfd-next&id=338a128142975439a19ab3c91480bc9d5a71f033

laurentiu
