Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622Ab3BGKh3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 05:37:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52319 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754959Ab3BGKh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 05:37:27 -0500
Date: Thu, 7 Feb 2013 11:37:06 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: arnd@arndb.de, axboe@kernel.dk, cbou@mail.ru, davem@davemloft.net,
        dtor@mail.ru, dwmw2@infradead.org, grant.likely@secretlab.ca,
        gregkh@linuxfoundation.org, jslaby@suse.cz, khali@linux-fr.org,
        mchehab@redhat.com, perex@perex.cz, sameo@linux.intel.com,
        tiwai@suse.de, w.sang@pengutronix.de, linux-kernel@vger.kernel.org,
        sebott@linux.vnet.ibm.com, gerald.schaefer@de.ibm.com,
        schwidefsky@de.ibm.com
Subject: Re: [PATCH 07/15] drivers/hid: add missing GENERIC_HARDIRQ
 dependency
In-Reply-To: <1360167843-3587-8-git-send-email-heiko.carstens@de.ibm.com>
Message-ID: <alpine.LNX.2.00.1302071136560.16860@pobox.suse.cz>
References: <1360167843-3587-1-git-send-email-heiko.carstens@de.ibm.com> <1360167843-3587-8-git-send-email-heiko.carstens@de.ibm.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2013, Heiko Carstens wrote:

> HID Sensors framework support (CONFIG_HID_SENSOR_HUB) unconditionally
> selects MFD_CORE which however depends on GENERIC_HARDIRQS.
> So add this dependency to HID_SENSOR_HUB as well.

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
