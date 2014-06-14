Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218AbaFNTCd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 15:02:33 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46220 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbaFNTCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 15:02:32 -0400
Date: Sat, 14 Jun 2014 21:01:59 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Varka Bhadram <varkab@cdac.in>
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: device tree: compilation of device tree sources
Message-ID: <20140614190159.GF15686@pengutronix.de>
References: <539AE266.70306@cdac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <539AE266.70306@cdac.in>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 21:01:24 up 52 days, 12:32, 42 users,  load average: 0.06, 0.06,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 05:07:10PM +0530, Varka Bhadram wrote:
> Hi,
> 
> I cloned the device tree git from: https://kernel.googlesource.com/pub/scm/linux/kernel/git/devicetree/devicetree-rebasing
> 
> When i try to compile the Makefile is throwing errors like this:
> 
> DTC     src/arc/abilis_tb100_dvk.dtb
> 
> dtc: invalid option -- 'i'

Your dtc version is too old. Please upgrade.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
