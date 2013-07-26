Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab3GZGTz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 02:19:55 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:59443 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149Ab3GZGTt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 02:19:49 -0400
Date: Fri, 26 Jul 2013 08:19:53 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Mark Brown <broonie@kernel.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Rob Herring <rob.herring@calxeda.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 1/4] ASoc: kirkwood: change the pcm/dma stream data
 pointer
Message-ID: <20130726081953.785c8527@armhf>
In-Reply-To: <20130725182356.GN9858@sirena.org.uk>
References: <20130725111314.66b811bc@armhf>
	<20130725093855.GB24642@n2100.arm.linux.org.uk>
	<20130725182356.GN9858@sirena.org.uk>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jul 2013 19:23:56 +0100
Mark Brown <broonie@kernel.org> wrote:

> On Thu, Jul 25, 2013 at 10:38:55AM +0100, Russell King - ARM Linux wrote:
> 
> > There's a much better solution to this, which is to get rid of
> > kirkwood_dma_priv entirely:
> 
> This does seem a lot nicer, can we either grab the relevant patch from
> your tree or update this one to use the same approach?

Russel's solution works fine for me, so my patch 1/4 may be cancelled.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
