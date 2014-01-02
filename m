Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586AbaABLob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 06:44:31 -0500
Received: from smtp2-g21.free.fr ([212.27.42.2]:34278 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbaABLo3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 06:44:29 -0500
Date: Thu, 2 Jan 2014 12:43:31 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Mark Brown <broonie@kernel.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Liam Girdwood <lgirdwood@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH] ASoC: generic: add generic compound card
 with DT support
Message-ID: <20140102124331.2bcfc172@armhf>
In-Reply-To: <20140102111056.GT31886@sirena.org.uk>
References: <20131231113138.102044cf@armhf>
	<52C466E1.3030302@metafoo.de>
	<20140101210814.31e3f3a9@armhf>
	<52C4766B.8080000@metafoo.de>
	<20140102102647.6efec89d@armhf>
	<20140102111056.GT31886@sirena.org.uk>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Jan 2014 11:10:56 +0000
Mark Brown <broonie@kernel.org> wrote:

> On Thu, Jan 02, 2014 at 10:26:47AM +0100, Jean-Francois Moine wrote:
> 
> > 		/* audio */
> > 		port@1 {
> > 			hdmi_i2s_audio: endpoint@0 {
> > 				reg = <0x03>;
> > 				remote-endpoint = <&audio_hdmi_i2s>;
> > 			};
> 
> I think we want an explicit object in the card representing the DAIs.
> This will both be useful for making it easy to find the configuration
> for the link and will be more extensible for the cases where multiple
> devices are connected, you can't just assume there's just two.

I don't see the problem: the 'port' is the DAI. The associated
endpoints give the DAI links and the routing information.

As the DT definition has been done for video, some properties may be
added at will for audio.

What kind of object were you thinking of?

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
