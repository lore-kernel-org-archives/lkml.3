Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbaJ1Ozg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 10:55:36 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:47727 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbaJ1Oze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 10:55:34 -0400
MIME-Version: 1.0
In-Reply-To: <1413479495-14206-3-git-send-email-soren.brinkmann@xilinx.com>
References: <1413479495-14206-1-git-send-email-soren.brinkmann@xilinx.com>
	<1413479495-14206-3-git-send-email-soren.brinkmann@xilinx.com>
Date: Tue, 28 Oct 2014 15:55:34 +0100
Message-ID: <CACRpkdYDDm1ZL1EVNBzvJaCR7oT-NagJT2bmscMAu=3PJ1pX_g@mail.gmail.com>
Subject: Re: [PATCH RFC v2 2/8] pinctrl: pinconf-generic: Add flag to print arguments
From: Linus Walleij <linus.walleij@linaro.org>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 7:11 PM, Soren Brinkmann
<soren.brinkmann@xilinx.com> wrote:

> When dumping pinconf information in debugfs, config arguments are only
> printed when a unit is present and the argument is != 0. For parameters
> like the slew rate, this does not work. The slew rate uses a driver
> specific format for the argument, i.e. 0 can be a valid argument and a
> unit is not provided for it.
> For that reason, add a flag to enable printing the argument instead of
> inferring it from the presence of a unit and the value of the argument.
>
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>

Patch applied.

Yours,
Linus Walleij
