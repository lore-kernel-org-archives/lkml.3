Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbaICGrA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 02:47:00 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:14144 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146AbaICGq6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 02:46:58 -0400
Date: Wed, 3 Sep 2014 08:48:14 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>
Cc: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "perex@perex.cz" <perex@perex.cz>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "tiwai@suse.de" <tiwai@suse.de>, "andrew@lunn.ch" <andrew@lunn.ch>,
        "kuninori.morimoto.gx@renesas.com" <kuninori.morimoto.gx@renesas.com>,
        "jsarha@ti.com" <jsarha@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCHv2 1/4] ASoC: simple-card: add
 asoc_simple_card_fmt_master() to simplify the code.
Message-ID: <20140903084814.0949534c@armhf>
In-Reply-To: <87wq9l5ojn.wl%kuninori.morimoto.gx@gmail.com>
References: <1409649969-15759-1-git-send-email-Li.Xiubo@freescale.com>
	<1409649969-15759-2-git-send-email-Li.Xiubo@freescale.com>
	<87egvt7dmd.wl%kuninori.morimoto.gx@gmail.com>
	<df7936d5863948b0a0a33aa8283d6a67@BY2PR0301MB0613.namprd03.prod.outlook.com>
	<87wq9l5ojn.wl%kuninori.morimoto.gx@gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Sep 2014 21:13:52 -0700 (PDT)
Kuninori Morimoto <kuninori.morimoto.gx@gmail.com> wrote:

> OK, will do.
> To avoid confusion/conflict, I will post it after Mark applied it.
> Because many simple-card patches are posted in these days...

Yes, I have one more awaiting, about multi-CODECs...

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
