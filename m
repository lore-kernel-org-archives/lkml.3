Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247AbaFWQ0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 12:26:48 -0400
Received: from alfter.us ([96.126.100.72]:52695 "EHLO alfter.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755451AbaFWQ0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 12:26:44 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Jun 2014 12:26:44 EDT
Message-ID: <89597b8dd96b8e07df45b2b4a7fb0d9b.squirrel@webmail.alfter.us>
In-Reply-To: <12173493.Olv1pKMOGK@wuerfel>
References: <12173493.Olv1pKMOGK@wuerfel>
Date: Mon, 23 Jun 2014 16:19:58 -0000
Subject: Re: [PATCH] w1: select crc16 library for ds2406
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: "Evgeniy Polyakov" <zbr@ioremap.net>, linux-kernel@vger.kernel.org,
        "Scott Alfter" <scott@alfter.us>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
User-Agent: SquirrelMail/1.4.23 [SVN]
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Delivery-Agent: TMDA/1.1.12 (Macallan)
From: Scott Alfter <scott@alfter.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, June 23, 2014 14:31, Arnd Bergmann wrote:
> commit 94859308a21b "w1: new w1_ds2406 driver" added a new driver
> that uses the crc16 library, but didn't ensure that the core is
> there. This adds the necessary Kconfig statements, just like we
> have it for other w1 drivers.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Scott Alfter <scott@alfter.us>
> Cc: Evgeniy Polyakov <zbr@ioremap.net>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Sounds OK to me...was an oversight on my part. Do I need to put together
another patchfile, or can this one be combined with the one I've already
sent in? As an alternative, it's in my kernel tree at
https://github.com/salfter/adafruit-raspberrypi-linux.

Scott Alfter
scott@alfter.us


