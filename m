Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab3LUOnb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 09:43:31 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40485 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020Ab3LUOna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 09:43:30 -0500
Date: Sat, 21 Dec 2013 14:42:58 +0000
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: perex@perex.cz, tiwai@suse.de, kuninori.morimoto.gx@renesas.com,
        fabio.estevam@freescale.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20131221144258.GM30815@sirena.org.uk>
References: <1387521591-15262-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387521591-15262-1-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 217.42.81.147
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: simple-card: Add cpu_dai and codec_dai names NULL
 check
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 02:39:50PM +0800, Xiubo Li wrote:
> The name of cpu DAI maybe omitted, and then strlen() will lead
> kernel panic.

Applied, thanks.
