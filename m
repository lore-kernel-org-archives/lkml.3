Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718Ab3BFVMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 16:12:42 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:43852 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758429Ab3BFVMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 16:12:38 -0500
Date: Wed, 06 Feb 2013 16:12:34 -0500 (EST)
Message-Id: <20130206.161234.1709943113064921095.davem@davemloft.net>
To: heiko.carstens@de.ibm.com
Cc: arnd@arndb.de, axboe@kernel.dk, cbou@mail.ru, dtor@mail.ru,
        dwmw2@infradead.org, grant.likely@secretlab.ca,
        gregkh@linuxfoundation.org, jkosina@suse.cz, jslaby@suse.cz,
        khali@linux-fr.org, mchehab@redhat.com, perex@perex.cz,
        sameo@linux.intel.com, tiwai@suse.de, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, sebott@linux.vnet.ibm.com,
        gerald.schaefer@de.ibm.com, schwidefsky@de.ibm.com
Subject: Re: [PATCH 10/15] drivers/net,AT91RM9200: add missing
 GENERIC_HARDIRQS dependency
From: David Miller <davem@davemloft.net>
In-Reply-To: <1360167843-3587-11-git-send-email-heiko.carstens@de.ibm.com>
References: <1360167843-3587-1-git-send-email-heiko.carstens@de.ibm.com>
	<1360167843-3587-11-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Wed,  6 Feb 2013 17:23:58 +0100

> The AT91RM9200 driver call devm_request_irq() and therefore should
> depend on GENERIC_HARDIRQS to prevent link/compile errors on plaforms
> without GENERIC_HARDIRQS.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

Acked-by: David S. Miller <davem@davemloft.net>
