Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198AbaI2OA5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:00:57 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:52853 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110AbaI2OAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:00:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: zhang.lyra@gmail.com
Cc: catalin.marinas@arm.com, gregkh@linuxfoundation.org,
        ijc+devicetree@hellion.org.uk, jslaby@suse.cz, galak@codeaurora.org,
        broonie@linaro.org, mark.rutland@arm.com, m-karicheri2@ti.com,
        pawel.moll@arm.com, artagnon@gmail.com, rrichter@cavium.com,
        robh+dt@kernel.org, will.deacon@arm.com, orsonzhai@gmail.com,
        geng.ren@spreadtrum.com, zhizhou.zhang@spreadtrum.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        "chunyan.zhang" <chunyan.zhang@spreadtrum.com>
Subject: Re: [PATCH 6/6] Documentation: Add entry for Spreadtrum's Shark64 SoC
Date: Mon, 29 Sep 2014 15:59:46 +0200
Message-ID: <3268049.TolhrmBCZA@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1411992293-7729-7-git-send-email-zhang.lyra@gmail.com>
References: <1411992293-7729-1-git-send-email-zhang.lyra@gmail.com> <1411992293-7729-7-git-send-email-zhang.lyra@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Du4xM/0pQx8kV5ivBvj7nLRjvaMilWWgq38kkH/VS2m
 yKMYJoHd+XUTqVUHDx1lcqIa3HYbYRqfNjHcjFJ8Q5zfjb62S1
 z3AINf53NbncVyF6WONTgQ8YPIEF020RtMjxafCGSazJBoPlG4
 GyP6wM/e2n9NCJZEEohDXXfzBoHPd+PnGWDEc2Mc541vlrlSQz
 ylXfEs8k/O/KHI6p5Py9k/squuX67TXMSfyxeN4uIj47zVPfRX
 BypGWXqP5yt+UJ1+1dEuXOc/hgjW39oQ7GN2OjUkqlfZQrgcHn
 AP1rHUg9nDkAOQF+vLiq7LpISsSLvQULGkXXbCwveOHRVyWu9Q
 fWw7ZMTilj0SXvzkfyu4=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 September 2014 20:04:53 zhang.lyra@gmail.com wrote:
> From: "chunyan.zhang" <chunyan.zhang@spreadtrum.com>
> 
> Adds a devicetree binding documentation for Spreadtrum's Shark64 SoC.
> 
> Signed-off-by: chunyan.zhang <chunyan.zhang@spreadtrum.com>

One more thing: The email addresses look wrong, please use the form in
which you normally write the names, such as

Signed-off-by: Zhang Chunyan <chunyan.zhang@spreadtrum.com>

You can set the user name that git will add using the
'git config --global user.name ...'.

Also, I notice that the email from which the patch is sent does not
match the last 'Signed-off-by' line. If Chunyan and Lyra are both
your names, better pick one that you use for both the email and the
signoff. If you are Lyra and are posting a patch from Chunyan, please
add your own line below hers, like

Signed-off-by: Zhang Chunyan <chunyan.zhang@spreadtrum.com>
Signed-off-by: Zhang Lyra <zhang.lyra@gmail.com>

so that you include everybody who was involved in sending the
patch, but have your own list last.

	Arnd
