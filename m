Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbbA1Uwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:52:38 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:42157 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbbA1Uwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:52:35 -0500
MIME-Version: 1.0
In-Reply-To: <54C910FF.7090308@i2se.com>
References: <1419762402-4548-1-git-send-email-stefan.wahren@i2se.com>
	<CAHrpEqQ-eoqM3W1hYcS6EPTmur1FSfm8TeEjYrtZ+PquavL86w@mail.gmail.com>
	<201501220039.02073.marex@denx.de>
	<20150128015131.22722.22882@quantum>
	<CAHrpEqSFfdWsCif_wZO2ToRpwOuC2yt45+HwOpGgv+B=EwKTCw@mail.gmail.com>
	<54C905CA.80908@i2se.com>
	<CAHrpEqQ=7EZNzpt1tmjBUrH8oDzjQmCCOrZaH8MBdmvV1+uFZg@mail.gmail.com>
	<54C910FF.7090308@i2se.com>
Date: Wed, 28 Jan 2015 14:52:33 -0600
Message-ID: <CAHrpEqSVZTfbWvg7UaU3FmiU+KSqsONV0kYM_jbshNbREEM_YA@mail.gmail.com>
Subject: Re: [PATCH V2] clk: mxs: Fix invalid 32-bit access to frac registers
From: Zhi Li <lznuaa@gmail.com>
To: Stefan Wahren <stefan.wahren@i2se.com>
Cc: Marek Vasut <marex@denx.de>, Mike Turquette <mturquette@linaro.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>, harald@ccbib.org,
        Shawn Guo <shawn.guo@linaro.org>, Fabio Estevam <festevam@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 10:40 AM, Stefan Wahren <stefan.wahren@i2se.com> wrote:
> The clk init for the i.MX28 in the kernel tries to the set
> IO0FRAC and IO1FRAC at once. So this patch fix this problem.

Okay, I am  fine. I suggest add comment about only change one FRAC once.
