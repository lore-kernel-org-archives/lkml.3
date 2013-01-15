Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab3AOEwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 23:52:44 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:49702 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab3AOEwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 23:52:43 -0500
Message-ID: <1358225583.5576.1.camel@gitbox>
Subject: Re: [PATCH] timer: vt8500: Move timer code to drivers/clocksource
From: Tony Prisk <linux@prisktech.co.nz>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com, arm@kernel.org
Date: Tue, 15 Jan 2013 17:53:03 +1300
In-Reply-To: <50F433A9.8020105@wwwdotorg.org>
References: <1358140171-25390-1-git-send-email-linux@prisktech.co.nz>
	 <1358140171-25390-2-git-send-email-linux@prisktech.co.nz>
	 <50F433A9.8020105@wwwdotorg.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-14 at 09:34 -0700, Stephen Warren wrote:
> On 01/13/2013 10:09 PM, Tony Prisk wrote:
> > This patch moves arch-vt8500/timer.c into drivers/clocksource and
> > updates the necessary Kconfig/Makefile options.
> 
> > diff --git a/include/linux/vt8500_timer.h b/include/linux/vt8500_timer.h
> 
> > +#ifndef __VT8500_TIMER_H
> > +#define __VT8500_TIMER_H
> > +
> > +#include <asm/mach/time.h>
> > +
> > +void vt8500_timer_init(void);
> > +
> > +#endif
> 
> Is VT8500 DT-only? If so, it'd be nice not to add this header, but
> instead use CLOCKSOURCE_OF_DECLARE() inside the driver C file.

Agreed - I didn't like the header when I added it but I didn't know of
another way and based in on the sunxi code.

Unfortunately Olof already pulled it into arm-soc, so I will try get
another patch done to undo it :)

Regards
Tony P

