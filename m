Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbaIJUqv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 16:46:51 -0400
Received: from mout.perfora.net ([74.208.4.197]:50714 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720AbaIJUqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 16:46:49 -0400
Message-ID: <1410381967.16012.8.camel@localhost.localdomain>
Subject: Re: [PATCH 1/3] ASoC: tegra: add tegra sgtl5000 machine driver
From: Marcel Ziswiler <marcel@ziswiler.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        stefan@agner.ch
Date: Wed, 10 Sep 2014 22:46:07 +0200
In-Reply-To: <CAOMZO5BYGwHGSeHeaQxEO=BUBGbno9P29et582SDzmwmfVioZA@mail.gmail.com>
References: <cover.1410276224.git.marcel@ziswiler.com>
	 <f90791ebb1799a4aa62dd6b527885ddadae3c058.1410276224.git.marcel@ziswiler.com>
	 <CAOMZO5BYGwHGSeHeaQxEO=BUBGbno9P29et582SDzmwmfVioZA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:rsRG+h04UXFia0pWLrarn66GRdZeu65z8sxKd+rcF1v
 bk5T+Zl9cumVR8GQL4W8RYqVjAwR021V3SzSUpNsgbwtRJPXDq
 QrCtftfMn4/YYccAlZXAuO2kLSOQXAYili997JGfpBWcBiZIPo
 JztiyUdjcfSa6/IP5PFBlIL7N4L0GN3TfeBFQStjGKTdVE0akH
 YNR7EOIgiXu0FIWmfe7qAqVR2MWgZ/URm5hE5Ec0FYX98Z+i8p
 /4pGp1IrwsKBYEsKRvUXjJu23ifbk9ywD3g4JIQG9nOnV/oYll
 X6I78UQ7E7rr0yNRUtRVhucQCT+FLLjdjKm8K+moyRjVDhz+28
 CkRUHMdmM/K14GVK05tFW+KEaWQgUr07VdVLZ1Mfk
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-09 at 15:00 -0300, Fabio Estevam wrote:
> What about using the simple-audio-card binding instead of adding the
> tegra_sgtl5000 machine driver?

Good question. I have to admit last I checked on the current state of
affairs on vybrid towards end of last year none of this existed yet.
Sweet. Will try and resubmit v2 with that in mind.

> An example of simple-audio-card used with sgtl5000 can be found here:
> 
> http://www.spinics.net/lists/devicetree/msg44466.html

While above linked example does not quite look like a proper example
thereof I do get the point. Please excuse my ignorance.

