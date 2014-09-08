Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbaIHVVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 17:21:39 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:35093 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391AbaIHVVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 17:21:37 -0400
Date: Mon, 8 Sep 2014 14:21:33 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Benjamin Valentin <benpicco@zedat.fu-berlin.de>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ted Mielczarek <ted@mielczarek.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH] xpad: sync device IDs with xboxdrv
Message-ID: <20140908212133.GA24033@core.coreip.homeip.net>
References: <20140906144727.29b44f5a@rechenknecht2k7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140906144727.29b44f5a@rechenknecht2k7>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 06, 2014 at 02:47:27PM +0200, Benjamin Valentin wrote:
> The userspace xboxdrv driver knows some more device ids than the kernel.
> This patch adds the missing xbox gamepads from [1] to xpad.c
> 
> [1] https://github.com/Grumbel/xboxdrv/blob/master/src/xpad_device.cpp
> 
> Signed-off-by: Benjamin Valentin <benpicco@zedat.fu-berlin.de>


Applied, thank you.

-- 
Dmitry
