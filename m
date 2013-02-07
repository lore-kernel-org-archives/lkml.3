Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444Ab3BGHkW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 02:40:22 -0500
Received: from mga11.intel.com ([192.55.52.93]:15278 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535Ab3BGHkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 02:40:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,619,1355126400"; 
   d="scan'208";a="283898761"
Date: Thu, 7 Feb 2013 08:39:55 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: arnd@arndb.de, axboe@kernel.dk, cbou@mail.ru, davem@davemloft.net,
        dtor@mail.ru, dwmw2@infradead.org, grant.likely@secretlab.ca,
        gregkh@linuxfoundation.org, jkosina@suse.cz, jslaby@suse.cz,
        khali@linux-fr.org, mchehab@redhat.com, perex@perex.cz, tiwai@suse.de,
        w.sang@pengutronix.de, linux-kernel@vger.kernel.org,
        sebott@linux.vnet.ibm.com, gerald.schaefer@de.ibm.com,
        schwidefsky@de.ibm.com
Subject: Re: [PATCH 03/15] drivers/mfd: add missing GENERIC_HARDIRQS
 dependecies
Message-ID: <20130207073955.GE3418@sortiz-mobl>
References: <1360167843-3587-1-git-send-email-heiko.carstens@de.ibm.com>
 <1360167843-3587-4-git-send-email-heiko.carstens@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360167843-3587-4-git-send-email-heiko.carstens@de.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heiko,

On Wed, Feb 06, 2013 at 05:23:51PM +0100, Heiko Carstens wrote:
> A lot of mfd drivers select MFD_CORE which however depends on
> GENERIC_HARDIRQS support.
> So add the missing dependency to all drivers to get rid of
> this link error:
> 
> ERROR: "irq_create_mapping" [drivers/mfd/mfd-core.ko] undefined!
> 
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
>  drivers/mfd/Kconfig |   72 +++++++++++++++++++++++++++------------------------
>  1 file changed, 38 insertions(+), 34 deletions(-)
> 
Applied to my for-next branch, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
