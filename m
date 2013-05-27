Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758215Ab3E0ObK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 10:31:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33228 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758054Ab3E0ObJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 10:31:09 -0400
Date: Mon, 27 May 2013 16:31:07 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Colin Leitner <colin.leitner@googlemail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid: driver for PS2/3 Buzz controllers
In-Reply-To: <1369587150.4240.4.camel@roadrunner.fritz.box>
Message-ID: <alpine.LNX.2.00.1305271628540.3914@pobox.suse.cz>
References: <1369587150.4240.4.camel@roadrunner.fritz.box>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 May 2013, Colin Leitner wrote:

> Added a driver for PlayStation 2/3 Buzz controllers, which exposes the LEDs and
> maps all buttons to BTN_TRIGGER_HAPPY1 to 20.
> 
> Applies to kernel version 3.10.0-rc2. Tested with Debian 7 and with a minor
> change on kernel 3.8.5 on Fedora 18. Couldn't test the wireless version, but
> what can be gathered on information from the net, both should be identical in
> their report structure.
> 
> Signed-off-by: Colin Leitner <colin.leitner@gmail.com>
> Cc: Jiri Kosina <jkosina@suse.cz>
> Cc: linux-input@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/hid/Kconfig    |  10 ++
>  drivers/hid/Makefile   |   1 +
>  drivers/hid/hid-buzz.c | 309 +++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/hid/hid-core.c |   4 +
>  drivers/hid/hid-ids.h  |   2 +
>  5 files changed, 326 insertions(+)

Hi Colin,

thanks a lot for the support.

I this it'd actually make more sense to add this support to one of the two 
existing drivers (*) we already have for Sony remote controllers -- either 
hid-sony or hid-ps3remote both seem appropriate.

(*) I think we should even merge hid-ps3remote into hid-sony.

Thanks,

-- 
Jiri Kosina
SUSE Labs
