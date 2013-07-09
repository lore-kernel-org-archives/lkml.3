Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463Ab3GIQOv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 12:14:51 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:36593 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab3GIQOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 12:14:47 -0400
Date: Tue, 9 Jul 2013 18:14:34 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Neil Zhang <zhangwm@marvell.com>
Cc: <grant.likely@linaro.org>, <haojian.zhuang@gmail.com>, <arnd@arndb.de>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH V3 2/3] clocksource: mmp: support CLOCKSOURCE OF DECLARE
Message-ID: <20130709181434.76f6216d@skate>
In-Reply-To: <1373352166-10064-3-git-send-email-zhangwm@marvell.com>
References: <1373352166-10064-1-git-send-email-zhangwm@marvell.com>
	<1373352166-10064-3-git-send-email-zhangwm@marvell.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Neil Zhang,

On Tue, 9 Jul 2013 14:42:45 +0800, Neil Zhang wrote:
> support CLOCKSOURCE OF DECLARE for mmp timer.
> 
> Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> ---
>  arch/arm/mach-mmp/mmp-dt.c  |    5 ++---
>  arch/arm/mach-mmp/mmp2-dt.c |    3 +--
>  arch/arm/mach-mmp/time.c    |   15 ++-------------
>  3 files changed, 5 insertions(+), 18 deletions(-)

Maybe it would be good to take this opportunity to move
arch/arm/mach-mmp/time.c into drivers/clocksource/.

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
