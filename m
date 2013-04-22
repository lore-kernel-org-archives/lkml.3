Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab3DVIID (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 04:08:03 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:43965 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293Ab3DVIIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 04:08:00 -0400
Message-ID: <5174EFDE.6080009@free-electrons.com>
Date: Mon, 22 Apr 2013 10:07:58 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: linux-arm-kernel@lists.infradead.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Marek Vasut <marex@denx.de>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        Brian Lilly <brian@crystalfontz.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] video: mxsfb: Fix colors display on lower color depth
References: <516EBCA4.1020609@free-electrons.com> <1366277032-671-1-git-send-email-maxime.ripard@free-electrons.com> <20130418144838.GD2222@S2101-09.ap.freescale.net>
In-Reply-To: <20130418144838.GD2222@S2101-09.ap.freescale.net>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shawn,

Le 18/04/2013 16:48, Shawn Guo a écrit :
> Copy Sascha.

Ah, yes, sorry, I somehow got confused and thought you were the one that
wrote the driver.

I'll resend the patch.

Maxime

-- 
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
