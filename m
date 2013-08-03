Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514Ab3HCPy2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 11:54:28 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:50958 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234Ab3HCPy1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 11:54:27 -0400
Date: Sat, 3 Aug 2013 17:55:13 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Rob Herring <rob.herring@calxeda.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 1/4] ASoc: kirkwood: simplify probe error
Message-ID: <20130803175513.7b765b0d@armhf>
In-Reply-To: <20130803123954.GX23006@n2100.arm.linux.org.uk>
References: <20130731081739.76aae84c@armhf>
	<20130803123954.GX23006@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Aug 2013 13:39:54 +0100
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> This doesn't apply to mainline as there's a clk_put() there.

Right, it applies to linux-next:

On Fri, 26 Jul 2013 11:32:50 +0100, Mark Brown <broonie@kernel.org> wrote:

> Always submit against where the code will be applied - -next in this
> case.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
