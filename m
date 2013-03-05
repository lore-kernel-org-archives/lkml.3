Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab3CEW1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 17:27:41 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:63510 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197Ab3CEW1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 17:27:40 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/9] ARM: omap1: add back missing includes
Date: Tue, 5 Mar 2013 22:27:33 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org
References: <1362521809-22989-1-git-send-email-arnd@arndb.de> <1362521809-22989-6-git-send-email-arnd@arndb.de>
In-Reply-To: <1362521809-22989-6-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303052227.33430.arnd@arndb.de>
X-Provags-ID: V02:K0:+rc8/RmTNxExL87dk3j9xp/Aw+itM/En53BhO+RJIMr
 9u/5DxO/cdzBf4dGqbtjLct42wRMg4TAzXIwOIx9JuRuQqAVVj
 2N5DMr6f585VMFFaMjj4dYM7JnSs7nU5OOOSdP9wc27+RED9iR
 8B9CYCSjv6uTrVZi5vM6xJPjuWs2vm1fuhFCF3SxlNwfJYVjqM
 snYEz4uDfu4q2sFLfS8uYIes85ih/A3dSWh+akW1tuJ+u2jCfy
 zvI9fmzMcKRKVtxj+HOF0jJwoqnilZ3YWOd34ODp8v7iygFHbV
 E69KFZmQSjnFSF3+jsnKM6/vy7gJ7gEE7ecpmnJEgCmjej8bDa
 2mLQ7jPriRCGc5vkUTyw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 March 2013, Arnd Bergmann wrote:
> The recent reorganization of OMAP header files caused a couple of
> files that used to be implicitly included now missing from OMAP1.
> This adds explicit inclusions of mach/irqs.h and mach/hardware.h
> in all files that need them for an OMAP1 allyesconfig build.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: linux-omap@vger.kernel.org
> ---
>  arch/arm/mach-omap1/board-fsample.c  | 1 +
>  arch/arm/mach-omap1/board-h2.c       | 1 +
>  arch/arm/mach-omap1/board-perseus2.c | 1 +
>  arch/arm/mach-omap1/board-sx1.c      | 1 +
>  drivers/video/omap/lcd_ams_delta.c   | 1 +
>  drivers/video/omap/lcd_osk.c         | 1 +
>  6 files changed, 6 insertions(+)

I saw that Tony has already addressed the latter two changes, but
did not see a fix for the four board files.

	Arnd
