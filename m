Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab3BNEWQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 23:22:16 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:56717 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257Ab3BNEWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 23:22:15 -0500
Date: Wed, 13 Feb 2013 20:22:11 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: arnd@arndb.de, axboe@kernel.dk, cbou@mail.ru, davem@davemloft.net,
        dwmw2@infradead.org, grant.likely@secretlab.ca,
        gregkh@linuxfoundation.org, jkosina@suse.cz, jslaby@suse.cz,
        khali@linux-fr.org, mchehab@redhat.com, perex@perex.cz,
        sameo@linux.intel.com, tiwai@suse.de, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, sebott@linux.vnet.ibm.com,
        gerald.schaefer@de.ibm.com, schwidefsky@de.ibm.com
Subject: Re: [PATCH 01/15] drivers/input: add couple of missing
 GENERIC_HARDIRQS dependencies
Message-ID: <20130214042211.GA2472@core.coreip.homeip.net>
References: <1360167843-3587-1-git-send-email-heiko.carstens@de.ibm.com>
 <1360167843-3587-2-git-send-email-heiko.carstens@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1360167843-3587-2-git-send-email-heiko.carstens@de.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 05:23:49PM +0100, Heiko Carstens wrote:
> When removing the !S390 dependency from drivers/input/Kconfig a couple
> of drivers don't compile because they have a dependency on GENERIC_HARDIRQS.
> So add the missing dependencies.
> Fixes e.g. this one:
> 
> drivers/input/keyboard/lm8323.c: In function ‘lm8323_suspend’:
> drivers/input/keyboard/lm8323.c:801:2: error: implicit declaration of function ‘irq_set_irq_wake’
> 	[-Werror=implicit-function-declaration]
> 
> Cc: Dmitry Torokhov <dtor@mail.ru>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

Queued for 3.9, thanks Heiko.

-- 
Dmitry
