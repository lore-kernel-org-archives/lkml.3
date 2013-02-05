Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab3BEKu4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 05:50:56 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13632 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab3BEKux convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 05:50:53 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 05 Feb 2013 02:50:27 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: Prashant Gaikwad <pgaikwad@nvidia.com>
CC: "mturquette@linaro.org" <mturquette@linaro.org>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Tue, 5 Feb 2013 11:50:48 +0100
Subject: Re: [PATCH V2] clk: Add composite clock type
Thread-Topic: [PATCH V2] clk: Add composite clock type
Thread-Index: Ac4Djqj8/0sUnhVwT+uGgV+QgAefZg==
Message-ID: <20130205.125048.1813250873129029298.hdoyu@nvidia.com>
References: <1359965482-29655-1-git-send-email-pgaikwad@nvidia.com>
In-Reply-To: <1359965482-29655-1-git-send-email-pgaikwad@nvidia.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prashant Gaikwad <pgaikwad@nvidia.com> wrote @ Mon, 4 Feb 2013 09:11:22 +0100:
...
If you want to consider the consistency for the other tegra
clk_register(), the following comment can be added although this is a
common function.

+	/* Data in .init is copied by clk_register(), so stack variable OK */
> +       composite->hw.init = &init;
> +
> +       clk = clk_register(dev, &composite->hw);
