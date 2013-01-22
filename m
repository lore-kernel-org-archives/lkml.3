Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324Ab3AVD1E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 22:27:04 -0500
Received: from mga09.intel.com ([134.134.136.24]:29141 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755585Ab3AVD1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 22:27:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,511,1355126400"; 
   d="scan'208";a="250508726"
Date: Tue, 22 Jan 2013 04:26:56 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lars Poeschel <poeschel@lemonage.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-next] mfd: tps65910: add REGMAP_IRQ to Kconfig
Message-ID: <20130122032656.GN7409@sortiz-mobl>
References: <201301081139.03471.poeschel@lemonage.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201301081139.03471.poeschel@lemonage.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lars,

On Tue, Jan 08, 2013 at 11:39:03AM +0100, Lars Poeschel wrote:
> From: Lars Poeschel <poeschel@lemonage.de>
> 
> tps65910 driver is using regmap irq, so selecting it in
> Kconfig to honor this.
> 
> Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
> ---
>  drivers/mfd/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
Anilkumar already sent a similar patch for this build error.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
