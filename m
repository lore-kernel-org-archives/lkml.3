Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbaEGUTw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 16:19:52 -0400
Received: from mout.gmx.net ([212.227.15.19]:59380 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111AbaEGUTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 16:19:51 -0400
Date: Wed, 7 May 2014 22:19:41 +0200
From: Michael Brunner <mibru@gmx.de>
To: gundberg <per.gundberg@icomera.com>
Cc: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: kempld-wdt: Use the correct value when
 configuring the prescaler with the watchdog
Message-ID: <20140507221941.2d6468ae@mail.gmx.de>
In-Reply-To: <5359165F.5040102@icomera.com>
References: <5359165F.5040102@icomera.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:G2BYd7fLGXruaH6Htp+cjMovyR4nInhRsQVGu1fPk1x/laVY2hg
 3by+ha0gfhurErrd1rDXYUr+8gH+EgChezyz952PCnYsaXoI6et13vvHVnZEvYhLGiqCnni
 znYK6cn2XJ2FigwTexQCMsVToYzRcmxT0TbIaOzgwtAyjDQwO3rywOwJphQ+oLf2bRGN2+I
 2rp5355UOUpTdkcfRQtkw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2014 08:15:40 -0700, Guenter Roeck <linux@roeck-us.net>
wrote:
> On Thu, Apr 24, 2014 at 03:49:19PM +0200, gundberg wrote:
> > Use the prescaler index, rather than its value, to configure the
> > watchdog. This will prevent a mismatch with the prescaler used to
> > calculate the cycles.
> > 
> > Signed-off-by: Per Gundberg <per.gundberg@icomera.com>
> 
> Good catch. Looks correct to me. Michael, any comments ?
> 
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>

Setting the prescaler incorrectly this way can cause the system to
reboot nearly immediately when activating the watchdog - not good.
This should also be applied to the stable revisions as this code is
included since 3.11.

Reviewed-by: Michael Brunner <michael.brunner@kontron.com>
Tested-by: Michael Brunner <michael.brunner@kontron.com>

Thanks,
Michael
