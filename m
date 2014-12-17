Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751260AbaLQXEH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 18:04:07 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:57040 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbaLQXEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 18:04:05 -0500
X-Auth-Info: FPy+dlhK4nxAELfe3R+6vU/DZSs7nTFvZq3e9FJaewA=
From: Marek Vasut <marex@denx.de>
To: Stefan Wahren <stefan.wahren@i2se.com>
Subject: Re: [PATCH RFC] clk: mxs: Fix invalid 32-bit access to frac registers
Date: Wed, 17 Dec 2014 17:00:52 +0100
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.13.1; x86_64; ; )
Cc: Fabio Estevam <festevam@gmail.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1418570933-21585-1-git-send-email-stefan.wahren@i2se.com> <CAOMZO5CQjpYtrNTT65-ikJua4N_osYj4UVgm3EV+sEvVWF59cg@mail.gmail.com> <5491379F.3090607@i2se.com>
In-Reply-To: <5491379F.3090607@i2se.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201412171700.52323.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 17, 2014 at 08:58:23 AM, Stefan Wahren wrote:
> Hi Fabio,
> 
> Am 17.12.2014 um 03:44 schrieb Fabio Estevam:
> > Hi Stefan,
> > 
> > On Sun, Dec 14, 2014 at 3:16 PM, Stefan Wahren <stefan.wahren@i2se.com> 
wrote:
> >> Btw i hope this patch also fixes a SPI communication issue with our
> >> hardware which forces us to bypass ref_io1 for ssp2.
> > 
> > Does this patch fix the SPI issue?
> 
> unfortunately not. If the 3.19-rc1 has been released, i send the fixed
> patch.
> 
> I've the theory that's an initialization issue. I've never heard of SPI
> problems from the U-Boot users and we are using imx-bootlets.
> 
> I'll try to test it with U-Boot.

Please keep me in the loop, I'd be interested in what you find. Thanks!

Best regards,
Marek Vasut
