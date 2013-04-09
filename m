Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936859Ab3DIJZr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:25:47 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:42920 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934492Ab3DIJZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:25:42 -0400
MIME-Version: 1.0
In-Reply-To: <1365495975-792-1-git-send-email-michal.bachraty@streamunlimited.com>
References: <1365495975-792-1-git-send-email-michal.bachraty@streamunlimited.com>
Date: Tue, 9 Apr 2013 11:25:41 +0200
Message-ID: <CABJ1b_RW=UUxmTrYOsx2wsDm1egs9DL3dWtat0--5kqec9-rQA@mail.gmail.com>
Subject: Re: [PATCH] clk: si5351: Add gapless tuning for SI5351 PLL
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Michal Bachraty <michal.bachraty@streamunlimited.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        mturquette@linaro.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 9, 2013 at 10:26 AM, Michal Bachraty
<michal.bachraty@streamunlimited.com> wrote:
> For gapless tuning, there is no need for PLL reset and clkout power-down
> when tuning output. "silabs,gapless-tuning" parameter enables gapless tuning
> for specific clock output.

Michal,

does gapless tuning have any constraints? Can we use it for all rate
changes or determine the
need for pll reset by rate offset?

Sebastian
