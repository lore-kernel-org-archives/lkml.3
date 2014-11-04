Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066AbaKDLz6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 06:55:58 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42383 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaKDLz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 06:55:56 -0500
Message-ID: <1415102152.3701.13.camel@pengutronix.de>
Subject: Re: [PATCH] clk: Add PWM clock driver
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mike Turquette <mturquette@linaro.org>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Janusz =?UTF-8?Q?U=C5=BCycki?= <j.uzycki@elproma.com.pl>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-pwm@vger.kernel.org
Date: Tue, 04 Nov 2014 12:55:52 +0100
In-Reply-To: <20140927200122.19023.40310@quantum>
References: <5410AEFD.5030302@elproma.com.pl> <20140923085130.GO30514@ulmo>
	 <20140927200122.19023.40310@quantum>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.6-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, den 27.09.2014, 13:01 -0700 schrieb Mike Turquette:
> Quoting Thierry Reding (2014-09-23 01:51:31)
> > On Wed, Sep 10, 2014 at 10:05:17PM +0200, Janusz Użycki wrote:
> > > Hi,
> > > 
> > > http://patchwork.ozlabs.org/patch/359069/
> > > https://lkml.org/lkml/2014/6/12/186
> > > 
> > > Will the patch ever included to linux-next?
> > 
> > I've never seen this patch before. From a quick look it doesn't seem
> > like it would work as is, but the idea is certainly interesting. If
> > somebody decides to continue work on it, please Cc me and the linux-pwm
> > mailing list.
> 
> I just merged a gpio-controlled clock gate and I'm fine with a PWM clock
> output.
> 
> Janusz, how are you testing the clock driver?

On the BoundaryDevices Nitrogen6X board, the master clock to the OV5640
MIPI CSI-2 sensor module has to be provided by a PWM.

regards
Philipp

