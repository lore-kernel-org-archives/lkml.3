Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab3GWIoP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 04:44:15 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38179 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178Ab3GWIoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 04:44:12 -0400
Date: Tue, 23 Jul 2013 09:43:47 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Rob Herring <rob.herring@calxeda.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] ARM: kirkwood: enable S/PDIF
Message-ID: <20130723084347.GP24642@n2100.arm.linux.org.uk>
References: <20130723102320.56bc4555@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130723102320.56bc4555@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 10:23:20AM +0200, Jean-Francois Moine wrote:
> This patch enables S/PDIF.
> 
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>

I'm not submitting my patch to do this because:

(a) we don't know what effect this has on other hardware.
(b) Mark suggested that we use the slave PCM stuff to deal with this.  As
    yet, that's something which I haven't been able to get to grips with
    because ASoC is soo damned complicated and undocumented.
