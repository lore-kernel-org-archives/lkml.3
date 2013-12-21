Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab3LUOaJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 09:30:09 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53065 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020Ab3LUOaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 09:30:08 -0500
Date: Sat, 21 Dec 2013 14:29:59 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, alsa-devel@alsa-project.org
Message-ID: <20131221142959.GH30815@sirena.org.uk>
References: <1387468508-12286-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387468508-12286-1-git-send-email-lee.jones@linaro.org>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 217.42.81.147
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 00/10] ASoC: ARM: ux500: Better prepare for full Device
 Tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 03:54:57PM +0000, Lee Jones wrote:
> At this moment in time the Ux500 ASoC driver obtains its DMA information
> via AUXDATA platform data passing. To make the driver more independent
> we have to start extracting it from the Device Tree. This patch-set goes
> some way to ensure the ux500 Audio driver is ready for the switch over.

This all looks good to me, I guess it's OK if I merge the ARM patch?
