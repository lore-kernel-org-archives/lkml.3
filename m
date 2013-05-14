Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758916Ab3EOMhR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 08:37:17 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:59137 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758624Ab3EOMhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 08:37:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Paul Bolle <pebolle@tiscali.nl>, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: remove saarb and tavorevb3 machine drivers
Date: Tue, 14 May 2013 22:23:37 +0200
Message-ID: <2843869.zn4rrxyCrZ@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.8.0-17-generic; KDE/4.10.2; x86_64; ; )
In-Reply-To: <1368544041.1350.111.camel@x61.thuisdomein>
References: <1368544041.1350.111.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:yiSKqyWTAtsQ7LCuf4FKCf5bOKMIEjR1+y8+mo6zGjU
 btgX22T1RAVtL26wnZ6cTi9nOpxPBJb2O/gjMxYz69k8xTjjdb
 fqyelv7nST2ODwEYZ6UOJc/jfeDk1yPrtXnjX2D71TklFWRoFh
 8TdmsSf4yrr5Xd4yHMq/WrZJd3TRdqp9Sss6zjCP6dCHVwm+8G
 MBeKkKYmpN4jTOjvWhnuUUxs0Vha0WfMLOjaRrv2qms4rf5NIF
 /C3jysUll6WpqYS031o6x623y4GVUFRZX8No3f5FxzGfM3/Bjn
 I6Qm2qWRdiext6Ws8ZF7y3Ragm5jLQgtpH96Bdmck0tDc3Evmo
 YPlVVkHifu2LzVeH+mTQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 May 2013 17:07:21 Paul Bolle wrote:
> Support for PXA95x was removed in v3.8. This means that the Kconfig
> symbols MACH_SAARB and MACH_TAVOREVB3 are no longer available. This
> leaves the SoC Audio support for Marvell Saarb and Marvell Tavor EVB3
> unbuildable. Remove these drivers too.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Acked-by: Arnd Bergmann <arnd@arndb.de>
