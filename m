Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759662Ab3FCSuT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 14:50:19 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:61603 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148Ab3FCSuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 14:50:13 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Sourav Poddar <sourav.poddar@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH] serial: omap: repair building without PM_SLEEP
References: <1844339.mxci2DdvBF@wuerfel> <20130603170730.GA30767@kroah.com>
Date: Mon, 03 Jun 2013 11:50:09 -0700
In-Reply-To: <20130603170730.GA30767@kroah.com> (Greg Kroah-Hartman's message
	of "Mon, 3 Jun 2013 10:07:30 -0700")
Message-ID: <871u8jm3ku.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> On Sat, Jun 01, 2013 at 11:18:13AM +0200, Arnd Bergmann wrote:
>> A recent bug fix in 3.10, ddd85e225c "serial: omap: prevent runtime PM for
>> "no_console_suspend"", introduced a regression from an obvious typo:
>
> I don't see that commit id, or commit, in Linus's tree at all.  Where do
> you see it?

It's in linux-next (from your tty-next branch.)

>> drivers/tty/serial/omap-serial.c:1677:14: error: 'serial_omap_complete' 
>> 	undeclared here (not in a function)
>> 
>> This changes the incorrectly added macro to the one that we need instead.
>> 
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Kevin Hilman <khilman@linaro.org>

>> ---
>> Please apply for 3.10-rc
>
> Really?  It doesn't apply to 3.10-rc3 or -rc4 from what I can tell.

Right, this is -next material, not v3.10.

Kevin
