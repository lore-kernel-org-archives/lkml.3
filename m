Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab3ESIGr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 04:06:47 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:62210 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab3ESIGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 04:06:43 -0400
Message-ID: <51988815.40006@prisktech.co.nz>
Date: Sun, 19 May 2013 20:06:45 +1200
From: Tony Prisk <linux@prisktech.co.nz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tony Prisk <linux@prisktech.co.nz>
CC: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        tomi.valkeinen@ti.com, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 0/4] FB updates for 3.11
References: <1368868514-18975-1-git-send-email-linux@prisktech.co.nz>
In-Reply-To: <1368868514-18975-1-git-send-email-linux@prisktech.co.nz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/05/13 21:15, Tony Prisk wrote:
> Patch #1 - Move register defines inside the driver and drop the header.
> Patch #2 - Convert the register defines to use the vendor preferred names.
> Patch #3 - Add a device clock to wm8505fb. Without it, only the uboot
> initialized resolution is supported.
> Patch #4 - Add support for the VGA output found on the APC8750 board.
>
> Tony Prisk (4):
>    fb: vt8500: Move register defines inside driver
>    fb: vt8500: Convert to use vendor register names
>    fb: vt8500: Require a device clock for wm8505fb driver
>    fb: vt8500: Add VGA output support to wm8505fb driver.
>
>   .../devicetree/bindings/video/wm,wm8505-fb.txt     |    9 +-
>   drivers/video/wm8505fb.c                           |  195 ++++++++++++--
>   drivers/video/wm8505fb_regs.h                      |   76 ------
>   drivers/video/wmt_ge_rops.c                        |  280 +++++++++++++++-----
>   4 files changed, 394 insertions(+), 166 deletions(-)
>   delete mode 100644 drivers/video/wm8505fb_regs.h
>
Florian/Tomi,

Please ignore these patches. This driver needs a bit more work, so I 
will do a
more thorough series and resubmit.

Regards
Tony Prisk
