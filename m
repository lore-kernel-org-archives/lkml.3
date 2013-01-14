Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371Ab3ANFNa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 00:13:30 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:51686 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab3ANFNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 00:13:30 -0500
Message-ID: <1358140429.25452.1.camel@gitbox>
Subject: Re: [Bulk] [PATCH] timer: vt8500: Move timer code to
 drivers/clocksource
From: Tony Prisk <linux@prisktech.co.nz>
To: vt8500-wm8505-linux-kernel@googlegroups.com
Cc: Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, arm@kernel.org
Date: Mon, 14 Jan 2013 18:13:49 +1300
In-Reply-To: <1358140171-25390-2-git-send-email-linux@prisktech.co.nz>
References: <1358140171-25390-1-git-send-email-linux@prisktech.co.nz>
	 <1358140171-25390-2-git-send-email-linux@prisktech.co.nz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-14 at 18:09 +1300, Tony Prisk wrote:
> This patch moves arch-vt8500/timer.c into drivers/clocksource and
> updates the necessary Kconfig/Makefile options.
> 
> Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
> ---
>  arch/arm/mach-vt8500/Kconfig       |    1 +
>  arch/arm/mach-vt8500/Makefile      |    2 +-
>  arch/arm/mach-vt8500/common.h      |    1 -
>  arch/arm/mach-vt8500/timer.c       |  184 ------------------------------------
>  arch/arm/mach-vt8500/vt8500.c      |    1 +
>  drivers/clocksource/Kconfig        |    3 +
>  drivers/clocksource/Makefile       |    1 +
>  drivers/clocksource/vt8500_timer.c |  184 ++++++++++++++++++++++++++++++++++++
>  include/linux/vt8500_timer.h       |   22 +++++
>  9 files changed, 213 insertions(+), 186 deletions(-)
>  delete mode 100644 arch/arm/mach-vt8500/timer.c
>  create mode 100644 drivers/clocksource/vt8500_timer.c
>  create mode 100644 include/linux/vt8500_timer.h

Darn.. forgot the -m again. I'll await your feedback regarding the
basing of the patch first (and any other feedback), then I'll redo it
with the correct stats.

Regards
Tony P

