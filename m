Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138Ab3DONao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 09:30:44 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:47838 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab3DONam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 09:30:42 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] clk: add DT test clock consumer driver
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <1363439376-21294-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1363439376-21294-1-git-send-email-sebastian.hesselbarth@gmail.com>
Date: Mon, 15 Apr 2013 14:30:38 +0100
Message-Id: <20130415133038.2A7723E0AA8@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Mar 2013 14:09:36 +0100, Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> wrote:
> This driver adds a DT test clock consumer that exposes debugfs files to
> enable/disable and set/get rate of the attached programmable clock.
> During development of a i2c-attached clock generator I found it useful
> to debug the clock generator's internal pll settings by enforcing clock
> rates through debugfs.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

Rather that using a DT binding to enable this, would it not be better to
have the debug interface bound entirely at runtime, and be able to
attach to pretty much any clock. It is less usable if it requires
modifying the dtb to use a debug feature.

g.

