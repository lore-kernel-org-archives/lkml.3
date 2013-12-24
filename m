Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230Ab3LXNPJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 08:15:09 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46235 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab3LXNPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 08:15:07 -0500
Date: Tue, 24 Dec 2013 13:14:39 +0000
From: Mark Brown <broonie@kernel.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>
Message-ID: <20131224131439.GG30815@sirena.org.uk>
References: <1387847559-18330-1-git-send-email-sboyd@codeaurora.org>
 <1387847559-18330-4-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387847559-18330-4-git-send-email-sboyd@codeaurora.org>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 81.132.50.212
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4 03/15] clk: Add regmap core helpers for
 enable/disable/is_enabled
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 23, 2013 at 05:12:27PM -0800, Stephen Boyd wrote:
> The clock framework already has support for simple gate clocks
> but if drivers want to use the gate clock functionality they need
> to wrap the gate clock in another struct and chain the ops by
> calling the gate ops from their own custom ops. Plus the gate

Reviewed-by: Mark Brown <broonie@linaro.org>
