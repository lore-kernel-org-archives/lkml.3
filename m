Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbaIJUxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 16:53:07 -0400
Received: from mout.perfora.net ([74.208.4.196]:56643 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209AbaIJUxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 16:53:04 -0400
Message-ID: <1410382325.16012.11.camel@localhost.localdomain>
Subject: Re: [PATCH 1/3] ASoC: tegra: add tegra sgtl5000 machine driver
From: Marcel Ziswiler <marcel@ziswiler.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Fabio Estevam <festevam@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        stefan@agner.ch
Date: Wed, 10 Sep 2014 22:52:05 +0200
In-Reply-To: <541083EC.7080803@wwwdotorg.org>
References: <cover.1410276224.git.marcel@ziswiler.com>
		<f90791ebb1799a4aa62dd6b527885ddadae3c058.1410276224.git.marcel@ziswiler.com>
	 <CAOMZO5BYGwHGSeHeaQxEO=BUBGbno9P29et582SDzmwmfVioZA@mail.gmail.com>
	 <541083EC.7080803@wwwdotorg.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:7BKbBAghOpEUuG/JdFeQfwnk84M1zEpZfOEF7LqCg84
 wL4FgLI0cxJEqJMBxkzBSiVokv++ETiwyWRbUjP0EqKurecoX3
 xqIZmbKKgpHW3qzsCV8jP4ml/tpkCAt7B+vFgv7ylHt4nMnFyH
 yPrgv6YNjQnwu61SnYsbxYHSsRG+aZ8CP3OgWFEVzWcQVKbMZ0
 0neBASfF33TOZ0LbYj9zLffOQSXE+xjNCcc89bC7rE1Qte2Ufb
 i/+9Pg+29Mp4wbbeCjwWPiTcTO62SWa2BQ3QPTQ2exos93JTbg
 UH/Duut0eP9AZNwL/kDJFGYl0dd9natcOmuSUtcA5cqdWAPIDg
 xix/slcZfO8WioZQkZTp6YmODJtjCizFHIETHvLBZIjZ53rkpP
 IcMO7AhynJBeQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-10 at 11:01 -0600, Stephen Warren wrote:
> I don't think that will work; the Tegra audio complex requires some 
> clock management that doesn't immediately seem to fit into the 
> simple-audio-card concept.

Could you elaborate on that one? At least for our use case it seems to
work just fine. See v2 following ASAP.

