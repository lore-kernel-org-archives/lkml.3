Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951AbaGIIKR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 04:10:17 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:52742
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754715AbaGIIKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 04:10:15 -0400
X-IronPort-AV: E=Sophos;i="5.01,630,1400018400"; 
   d="scan'208";a="70652417"
Date: Wed, 9 Jul 2014 10:10:01 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Mark Brown <broonie@kernel.org>
cc: Fabio Estevam <festevam@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Takashi Iwai <tiwai@suse.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Himangi Saraogi <himangi774@gmail.com>
Subject: Re: [alsa-devel] [PATCH] ASoC: sgtl5000: Use devm_ functions
In-Reply-To: <20140709080134.GE30458@sirena.org.uk>
Message-ID: <alpine.DEB.2.10.1407091009450.2375@hadrien>
References: <20140706070800.GA2927@himangi-Dell> <20140707144832.GL30458@sirena.org.uk> <alpine.DEB.2.10.1407071655171.4757@hadrien> <CAOMZO5AiFCnfTzo4TyB5e5c+xiHQiHUbhRVY7z=AbjOWZDX3NA@mail.gmail.com> <alpine.DEB.2.10.1407071721270.4757@hadrien>
 <20140708080232.GQ30458@sirena.org.uk> <alpine.DEB.2.10.1407081012400.2347@hadrien> <20140708145249.GX30458@sirena.org.uk> <alpine.DEB.2.02.1407090727410.2022@localhost6.localdomain6> <20140709080134.GE30458@sirena.org.uk>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 9 Jul 2014, Mark Brown wrote:

> On Wed, Jul 09, 2014 at 07:30:40AM +0200, Julia Lawall wrote:
> > On Tue, 8 Jul 2014, Mark Brown wrote:
>
> > > All devices do this - it's done as part of the driver model core code so
> > > there is no need for individual buses to do anything.
>
> > How should one realize that this does not apply to the original file
> > under discussion, sound/soc/codecs/sgtl5000.c?  The associated structure
> > is snd_soc_codec_driver.  What code could one look for at the call sites
> > of the probe and remove functions to know that managed memory can be used?
>
> That's not a device model driver; the way you should realise this is
> that there's no device being registered on a bus which is matched by the
> driver core.

OK, thanks for the clarification.

julia
