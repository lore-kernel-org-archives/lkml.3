Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab3LXNNx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 08:13:53 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46216 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab3LXNNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 08:13:51 -0500
Date: Tue, 24 Dec 2013 13:13:27 +0000
From: Mark Brown <broonie@kernel.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>
Message-ID: <20131224131327.GF30815@sirena.org.uk>
References: <1387847559-18330-1-git-send-email-sboyd@codeaurora.org>
 <1387847559-18330-3-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387847559-18330-3-git-send-email-sboyd@codeaurora.org>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 81.132.50.212
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4 02/15] clk: Allow drivers to pass in a regmap
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 23, 2013 at 05:12:26PM -0800, Stephen Boyd wrote:
> Add support to the clock core so that drivers can pass in a
> regmap. If no regmap is specified try to query the device that's
> registering the clock for its regmap. This should allow drivers
> to use the core regmap helpers. This is based on a similar design
> in the regulator framework.

Reviewed-by: Mark Brown <broonie@linaro.org>
