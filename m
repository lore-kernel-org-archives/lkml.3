Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab3AYWJi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 17:09:38 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:56027 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969Ab3AYWJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 17:09:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 1/4 v11] arm: use device tree to get smp_twd clock
Date: Fri, 25 Jan 2013 23:15:39 +0100
Message-ID: <2022065.fFzVbP4vta@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130125214000.GA23505@n2100.arm.linux.org.uk>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com> <3041510.xugDHtFsGr@vostro.rjw.lan> <20130125214000.GA23505@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 25, 2013 09:40:00 PM Russell King - ARM Linux wrote:
> On Fri, Jan 25, 2013 at 10:03:05PM +0100, Rafael J. Wysocki wrote:
> > On Friday, January 25, 2013 01:46:42 PM Mark Langsdorf wrote:
> > > From: Rob Herring <rob.herring@calxeda.com>
> > > 
> > > Move clk setup to twd_local_timer_common_register and rely on
> > > twd_timer_rate being 0 to force calibration if there is no clock.
> > > Remove common_setup_called as it is no longer needed.
> > > 
> > > Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> > > Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
> > 
> > Russell, is this fine with you?
> 
> Looks fine to me, though I had to check twd_calibrate_rate() to make
> sure it wouldn't run if the twd_timer_rate was non-zero.
> 
> If you want an acked-by:
> 
> Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

I will, thanks a lot!

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
