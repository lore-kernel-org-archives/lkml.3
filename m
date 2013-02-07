Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834Ab3BGGhj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 01:37:39 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:35182
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750973Ab3BGGhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 01:37:34 -0500
Date: Thu, 7 Feb 2013 07:35:21 +0100
From: Jens Axboe <axboe@kernel.dk>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: arnd@arndb.de, cbou@mail.ru, davem@davemloft.net, dtor@mail.ru,
        dwmw2@infradead.org, grant.likely@secretlab.ca,
        gregkh@linuxfoundation.org, jkosina@suse.cz, jslaby@suse.cz,
        khali@linux-fr.org, mchehab@redhat.com, perex@perex.cz,
        sameo@linux.intel.com, tiwai@suse.de, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, sebott@linux.vnet.ibm.com,
        gerald.schaefer@de.ibm.com, schwidefsky@de.ibm.com
Subject: Re: [PATCH 04/15] drivers/block/mtip32xx: add missing
 GENERIC_HARDIRQS dependency
Message-ID: <20130207063521.GR15092@kernel.dk>
References: <1360167843-3587-1-git-send-email-heiko.carstens@de.ibm.com>
 <1360167843-3587-5-git-send-email-heiko.carstens@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360167843-3587-5-git-send-email-heiko.carstens@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06 2013, Heiko Carstens wrote:
> The MTIP32XX driver calls devm_request_irq() and therefore needs a
> GENERIC_HARDIRQS dependency to prevent building it on s390.

I'll queue this up for 3.9, thanks Heiko.

-- 
Jens Axboe

