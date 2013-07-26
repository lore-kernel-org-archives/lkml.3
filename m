Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398Ab3GZJtn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 05:49:43 -0400
Received: from smtp2-g21.free.fr ([212.27.42.2]:51155 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425Ab3GZJtk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 05:49:40 -0400
Date: Fri, 26 Jul 2013 11:49:46 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Rob Herring <rob.herring@calxeda.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 4/4] ASoc: kirkwood: add DT support
Message-ID: <20130726114946.1945bc1a@armhf>
In-Reply-To: <20130726092156.GK24642@n2100.arm.linux.org.uk>
References: <20130725111459.145a4aa4@armhf>
	<20130725191905.GR9858@sirena.org.uk>
	<20130725230533.GH24642@n2100.arm.linux.org.uk>
	<20130726110913.0a193918@armhf>
	<20130726092156.GK24642@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jul 2013 10:21:56 +0100
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Fri, Jul 26, 2013 at 11:09:13AM +0200, Jean-Francois Moine wrote:
> > The A510 documentation uses the names "DCO PLL" for the internal clock
> > and "AU_EXTCLK" for the external clock. So, what about "dcopll" and
> > "extclk"?
> 
> Stop naming them according to their source.  Their _consumer_ names
> not _source_ names.

I have no preference. What do you propose?

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
