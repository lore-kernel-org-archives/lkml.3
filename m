Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbaGHJhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 05:37:42 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:46153 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526AbaGHJhk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 05:37:40 -0400
Date: Tue, 8 Jul 2014 11:39:45 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Andrew Jackson <Andrew.Jackson@arm.com>
Cc: Mark Brown <broonie@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Clark <robdclark@gmail.com>, Dave Airlie <airlied@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [alsa-devel] [PATCH v2] ASoC: tda998x: add a codec to the HDMI
 transmitter
Message-ID: <20140708113945.29b6be7f@armhf>
In-Reply-To: <53BBB746.1000201@arm.com>
References: <20140704091733.10258cfe@armhf>
	<53BBB746.1000201@arm.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Jul 2014 10:17:58 +0100
Andrew Jackson <Andrew.Jackson@arm.com> wrote:

> > +       static const u32 hdmi_rates[] = {
> > +               32000, 44100, 48000, 88200, 9600, 176400, 192000
> > +       };
> > +  
> 
> Shouldn't this be 96000, not 9600?  Assuming that the table is ordered in terms of increasing frequencies.

You are right. Thank you.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
