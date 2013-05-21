Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075Ab3EUHDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 03:03:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:24107 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754157Ab3EUHDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 03:03:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,712,1363158000"; 
   d="scan'208";a="340915693"
Date: Tue, 21 May 2013 10:07:30 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: EUNBONG SONG <eunb.song@samsung.com>
Cc: wsa@the-dreams.de, linux-i2c@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c: i2c-designware: Fix compilation warning
Message-ID: <20130521070730.GJ11878@intel.com>
References: <2512686.216921369094149829.JavaMail.weblogic@epml25>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2512686.216921369094149829.JavaMail.weblogic@epml25>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 11:55:50PM +0000, EUNBONG SONG wrote:
> 
> Fix the following compilation warning when CONFIG_PM_RUNTIME is not enabled:
> 
> drivers/i2c/busses/i2c-designware-pcidrv.c:188: warning: 'i2c_dw_pci_runtime_idle' defined but not used
> 
> Signed-off-by: EunBong Song <eunb.song@samsung.com>

Thanks for fixing this!

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
