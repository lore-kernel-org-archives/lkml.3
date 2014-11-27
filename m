Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374AbaK0VwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 16:52:23 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:64733 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbaK0VwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 16:52:20 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux@arm.linux.org.uk,
        vinod.koul@intel.com, linux-mmc@vger.kernel.org, nsekhar@ti.com,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        khilman@deeprootsystems.com, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@kernel.org>, chris@printf.net,
        dmaengine@vger.kernel.org, ulf.hansson@linaro.org,
        linux-spi@vger.kernel.org
Subject: Re: [PATCH 2/3] ARM: edma: Rename header file for dmaengine filter function definition
Date: Thu, 27 Nov 2014 22:52:10 +0100
Message-ID: <4859328.eEV7jzKEaA@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54777174.4070203@ti.com>
References: <1417084891-17990-1-git-send-email-peter.ujfalusi@ti.com> <3300340.ou8f7H2hIc@wuerfel> <54777174.4070203@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:wMwH+rn/O7/e11eTcQFtsF22av0Pl4szbFuLe975Nj9
 dSfm1nUkv9joHdf1NyV+bYbxQCY2ZAcm1WgeFeO9yr18Kw2l3x
 q1AzlNorYZMZRHAWnh19YaItOcWAUpHVC+I5RP9tH4Xdd8ofic
 Rm6mMJtxzTT8KWHrcK+r9zGNTs3GSBSeRvvuljuY+IwQbU3m0c
 pSWvdoXeNMdauq7I778IMZLU+4UlaUcRZYzQxnUsb4/H1OwoFv
 Zx35fkhvC+HZ9w/ZjID7jtepwZBq0T67iCoh7azaJQDoRSvx3N
 cm/+gQdnJZBGGEWiE3ySC7OU/Cd6vhPv/pT+MAVoJD+xM3kyIu
 Szb43/aOQ0t4H350zz3s=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 November 2014 20:46:12 Peter Ujfalusi wrote:
> 
> I see. With this series I did not planed to fix all edma related issues, just
> as a start clean up the related header files. I would rather not add fixes to
> mmc, spi, etc drivers since while you have valid point it is not in the scope
> of this series.
> Can we do the changes you are suggesting in an incremental manner?

Sure, but I'd leave the existing filter function declaration alone then
and not move it, since we wouldn't want to keep it in the long run.

	Arnd
