Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428AbaKJJCj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 04:02:39 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:42516 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861AbaKJJCh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 04:02:37 -0500
Date: Mon, 10 Nov 2014 10:05:26 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/4] ASoC: simple-card: add multi-CODECs in DT
Message-ID: <20141110100526.76790f55@armhf>
In-Reply-To: <3271244.uSgBKXChSS@wuerfel>
References: <cover.1415605716.git.moinejf@free.fr>
	<d49d348da24fbd96e7be51ba2839ee8bc821ddec.1415605717.git.moinejf@free.fr>
	<3271244.uSgBKXChSS@wuerfel>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2014 09:39:57 +0100
Arnd Bergmann <arnd@arndb.de> wrote:

> On Sunday 09 November 2014 12:22:21 Jean-Francois Moine wrote:
> > -- sound-dai                            : phandle and port of CPU/CODEC
> > +either
> > +  - sound-dai                          : phandle and port of CPU/CODEC
> > +or
> > +  - sound-dais                         : list of phandle and port of CODECs
> 
> Is it really necessary to change the property name here? I woudl think
> that you can make it all work more consistently with just the existing
> 'sound-dai' property, just extend it to allow multiple codecs

This was an idea from Benoit Cousson:

 "Something like that:

   sound-dais = <&spdif_codec 1>, <&hdmi 0>;

 That being said, it will require changing the name with a plural form,"

As I coded it, both names are accepted for a single or many codecs.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
