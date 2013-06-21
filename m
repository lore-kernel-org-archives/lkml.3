Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423133Ab3FUGlh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 02:41:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:4334 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161440Ab3FUGlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 02:41:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,911,1363158000"; 
   d="scan'208";a="353375472"
Date: Fri, 21 Jun 2013 11:31:58 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Mark Brown <broonie@linaro.org>
Cc: Dan Williams <djbw@fb.com>, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Tomasz Figa <tomasz.figa@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmaengine: PL08x: Avoid collisions with get_signal()
 macro
Message-ID: <20130621060158.GD23141@intel.com>
References: <1371670708-26161-1-git-send-email-broonie@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371670708-26161-1-git-send-email-broonie@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 08:38:28PM +0100, Mark Brown wrote:
> As pointed out by Arnd Bergmann there is a get_signal macro definied in
> linux/signal.h which can conflict with the platform data callback
> function of the same name leading to confusing errors from the compiler
> (especially if signal.h manages to get pulled into the driver itself due
> to header dependencies).  Avoid such errors by renaming get_signal and
> put_signal in the platform data to get_xfer_signal and put_xfer_signal.
> 
> Signed-off-by: Mark Brown <broonie@linaro.org>
Applied, thanks

--
~Vinod
