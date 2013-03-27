Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138Ab3C0PWd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 11:22:33 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36622 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab3C0PWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 11:22:31 -0400
Date: Wed, 27 Mar 2013 16:22:11 +0100
From: Markus Pargmann <mpa@pengutronix.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, arvind.chauhan@arm.com, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, arnd.bergmann@linaro.org,
        linux@arm.linux.org.uk, Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH 4/9] cpufreq: imx: move cpufreq driver to
 drivers/cpufreq
Message-ID: <20130327152211.GD6347@pengutronix.de>
References: <cover.1364205812.git.viresh.kumar@linaro.org>
 <6c0d4611de3586b12d5df9beaa5d21e4703dd38b.1364205812.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6c0d4611de3586b12d5df9beaa5d21e4703dd38b.1364205812.git.viresh.kumar@linaro.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 16:19:26 up 18 days, 59 min, 18 users,  load average: 0.12, 0.16,
 0.15
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Mar 25, 2013 at 03:41:35PM +0530, Viresh Kumar wrote:
> This patch moves cpufreq driver of ARM based imx platform to drivers/cpufreq.

I sent a patch that removes imx-cpufreq which was applied by Shawn:
http://lists.infradead.org/pipermail/linux-arm-kernel/2013-March/158497.html

Regards,

Markus

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
