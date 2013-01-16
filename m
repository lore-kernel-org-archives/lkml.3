Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511Ab3APBkV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 20:40:21 -0500
Received: from mail-da0-f43.google.com ([209.85.210.43]:33268 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756690Ab3APBkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 20:40:19 -0500
Date: Tue, 15 Jan 2013 17:36:40 -0800
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH 03/18] power: ab8500_charger: Detect charger removal
Message-ID: <20130116013640.GA11105@lizard.fhda.edu>
References: <1357909986-9262-1-git-send-email-lee.jones@linaro.org>
 <1357909986-9262-4-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1357909986-9262-4-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 01:12:51PM +0000, Lee Jones wrote:
> Add two new work queues to provide USB and AC charger disconnect
> detection.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
[....]
> +		if ((statval & usbch)) != usbch)

  CC      drivers/power/ab8500_charger.o
drivers/power/ab8500_charger.c: In function ‘ab8500_charger_usb_attached_work’:
drivers/power/ab8500_charger.c:1812:26: error: expected expression before ‘!=’ token
drivers/power/ab8500_charger.c:1812:34: error: expected statement before ‘)’ token
drivers/power/ab8500_charger.c: In function ‘ab8500_charger_ac_attached_work’:
drivers/power/ab8500_charger.c:1852:27: error: expected expression before ‘!=’ token
drivers/power/ab8500_charger.c:1852:36: error: expected statement before ‘)’ token

I fixed it up...
