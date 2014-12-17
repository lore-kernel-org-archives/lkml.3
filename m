Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526AbaLQCoK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 21:44:10 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:33856 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaLQCoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 21:44:08 -0500
MIME-Version: 1.0
In-Reply-To: <1638147247.144508.1418577377536.JavaMail.open-xchange@oxbaltgw03.schlund.de>
References: <1418570933-21585-1-git-send-email-stefan.wahren@i2se.com>
	<201412141712.12589.marex@denx.de>
	<1638147247.144508.1418577377536.JavaMail.open-xchange@oxbaltgw03.schlund.de>
Date: Wed, 17 Dec 2014 00:44:06 -0200
Message-ID: <CAOMZO5CQjpYtrNTT65-ikJua4N_osYj4UVgm3EV+sEvVWF59cg@mail.gmail.com>
Subject: Re: [PATCH RFC] clk: mxs: Fix invalid 32-bit access to frac registers
From: Fabio Estevam <festevam@gmail.com>
To: Stefan Wahren <stefan.wahren@i2se.com>
Cc: Marek Vasut <marex@denx.de>, linux-kernel <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan,

On Sun, Dec 14, 2014 at 3:16 PM, Stefan Wahren <stefan.wahren@i2se.com> wrote:

> Btw i hope this patch also fixes a SPI communication issue with our hardware
> which forces us to bypass ref_io1 for ssp2.

Does this patch fix the SPI issue?
