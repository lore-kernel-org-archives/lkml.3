Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbaJTPBf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 11:01:35 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:52230 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbaJTPBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 11:01:31 -0400
From: Kevin Hilman <khilman@kernel.org>
To: Sudhir Sreedharan <ssreedharan@mvista.com>
Cc: peter@hurleysoftware.com, gregkh@linuxfoundation.org,
        linux-serial@vger.kernel.org, jslaby@suse.cz,
        linux-kernel@vger.kernel.org, olof@lixom.net,
        linux-arm-kernel@lists.infradead.org, geert@linux-m68k.org
Subject: Re: [PATCH v1] tty: serial: 8250_core: restore the LCR register in set_sleep
References: <CAJJ77WsAi5jmnDxY45ipu3a94D6+yoHJNHgExhFsVoirV3NoyQ@mail.gmail.com>
	<1413549558-24227-1-git-send-email-ssreedharan@mvista.com>
Date: Mon, 20 Oct 2014 08:01:27 -0700
In-Reply-To: <1413549558-24227-1-git-send-email-ssreedharan@mvista.com>
	(Sudhir Sreedharan's message of "Fri, 17 Oct 2014 18:09:18 +0530")
Message-ID: <7hppdmg4zc.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sudhir Sreedharan <ssreedharan@mvista.com> writes:

> In ST16650V2 based serial uarts, while initalizing the PM state,
> LCR registers are being initialized to 0 in serial8250_set_sleep().
> If console port is already initialized and being used, this will
> throws garbage in the console.
>
> Signed-off-by: Sudhir Sreedharan <ssreedharan@mvista.com>

Tested-by: Kevin Hilman <khilman@linaro.org>

I boot tested this on a bunch of ARM boards and don't see any
more failures/regressions.

Kevin
