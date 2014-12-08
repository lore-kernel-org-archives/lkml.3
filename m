Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753AbaLHOGi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 09:06:38 -0500
Received: from mga02.intel.com ([134.134.136.20]:9581 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755523AbaLHOGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 09:06:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,538,1413270000"; 
   d="scan'208";a="650282220"
Date: Mon, 8 Dec 2014 15:56:38 +0200
From: Laurentiu Palcu <laurentiu.palcu@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mark Brown <broonie@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: Re: linux-next: build failure after merge of the spi tree
Message-ID: <20141208135638.GG15450@lpalcu-linux>
References: <20141208230517.13ebfe4f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141208230517.13ebfe4f@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 11:05:17PM +1100, Stephen Rothwell wrote:
> Hi Mark,
> 
> After merging the spi tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/spi/spi-dln2.c: In function 'dln2_spi_copy_from_buf':
> drivers/spi/spi-dln2.c:415:4: error: implicit declaration of function 'get_unaligned_le32' [-Werror=implicit-function-declaration]
>     *d++ = get_unaligned_le32(s++);
>     ^
> 
> Caused by commit ffb9ad0a47b4 ("spi: add support for DLN-2 USB-SPI adapter").

Re-sent the patch with the asm/unaligned.h header included and I build tested
for PPC to make sure.

Sorry for the trouble... :/
laurentiu

