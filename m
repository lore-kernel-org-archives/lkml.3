Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbaJ1O7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 10:59:50 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:42778 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbaJ1O7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 10:59:48 -0400
MIME-Version: 1.0
In-Reply-To: <1413479495-14206-4-git-send-email-soren.brinkmann@xilinx.com>
References: <1413479495-14206-1-git-send-email-soren.brinkmann@xilinx.com>
	<1413479495-14206-4-git-send-email-soren.brinkmann@xilinx.com>
Date: Tue, 28 Oct 2014 15:59:48 +0100
Message-ID: <CACRpkdZtqNUroNfd_0Kftq+-056YFzjvR+ROrZZ0htZX2v2qzg@mail.gmail.com>
Subject: Re: [PATCH RFC v2 3/8] pinctrl: pinconf-generic: Add parameter 'IO standard'
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

> For HW that can select the IO standard for pins, add the infrastructure
> in pinconf generic to parse this parameter.
>
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>

Nothing in this patch actually explain what an "IO standard" is,
which is paramount if it should be a generic property.

And if it should be generic, I really want to know why this is a
thing not overlapping with existing generic configs, and exactly
what it is and that it is probable other silicon will have it too.
And we need to discuss if it's the right name.

Looking at what you actually set up, it looks very much like this
is actually PIN_CONFIG_DRIVE_STRENGTH.

Yours,
Linus Walleij
