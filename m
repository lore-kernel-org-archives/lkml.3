Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab3GEUzu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 16:55:50 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:59663 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab3GEUzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 16:55:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH] ASoC: Allow imx-pcm-{dma,fiq}.c to be modules
Date: Fri, 5 Jul 2013 22:55:10 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
References: <201307051745.16140.arnd@arndb.de> <20130705173321.GE27646@sirena.org.uk>
In-Reply-To: <20130705173321.GE27646@sirena.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201307052255.10765.arnd@arndb.de>
X-Provags-ID: V02:K0:N0aV4yVjU97ikbAMYDzixisaPDXzejrwxS7YqStR90q
 PZ1ccAKr8y/8DAoGe0e0f19vGOVBW4Wq6yVSF+OralTvMm7iUk
 IUmRMvZX0KfcYP2mkpJl43a6hQXl4Ztm1uAqTgF8f/GtaYj5uO
 TaJ0ehvCGyEWlBXJ8uyBK4Tmj1u02YUA9nP/7pCEPb714h1Ywb
 /Ey9R+//FMkGETVfbdxr7UFGNxeUS50OUfmxt+woiD0lgclJLF
 wBqznPT22h/MyKoQ+s4X1hUF8PUR4otF7pnQUHsdRllzc3QCQa
 R2oPJVX5mJuiDIOX1Tqp9P4A5ETnVL/xC4qS6bOfGw2K3vAdnX
 Y5aYmb3pByoEUOooVojE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 July 2013, Mark Brown wrote:
> On Fri, Jul 05, 2013 at 05:45:15PM +0200, Arnd Bergmann wrote:
> > This is required so we can build the imx sound support
> > when ALSA itself is a loadable module.
> 
> Is this actually OK with the FIQ APIs?
> 

I don't know. Why wouldn't it?

Other users of the same interfaces (mx1_camera, spi-s3c24xx) can also be
modules, so I wouldn't expect a fundamental issue.

	Arnd
