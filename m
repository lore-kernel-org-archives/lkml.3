Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab3AUQDk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 11:03:40 -0500
Received: from service87.mimecast.com ([91.220.42.44]:49103 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780Ab3AUQDh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 11:03:37 -0500
Message-ID: <1358784212.6590.30.camel@hornet>
Subject: Re: [PATCH 7/7] clk: vexpress: Use common of_clk_init() function
From: Pawel Moll <pawel.moll@arm.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Prashant Gaikwad <pgaikwad@nvidia.com>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>,
        "linux@prisktech.co.nz" <linux@prisktech.co.nz>,
        "josh.cartwright@ni.com" <josh.cartwright@ni.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Mon, 21 Jan 2013 16:03:32 +0000
In-Reply-To: <20130118175827.3982.65450@quantum>
References: <1357282858-2112-1-git-send-email-pgaikwad@nvidia.com>
	 <1357282858-2112-7-git-send-email-pgaikwad@nvidia.com>
	 <20130118175827.3982.65450@quantum>
X-Mailer: Evolution 3.6.2-0ubuntu0.1
Mime-Version: 1.0
X-OriginalArrivalTime: 21 Jan 2013 16:03:33.0039 (UTC) FILETIME=[DCB0ABF0:01CDF7F0]
X-MC-Unique: 113012116033505201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-01-18 at 17:58 +0000, Mike Turquette wrote:
> Quoting Prashant Gaikwad (2013-01-03 23:00:58)
> > Use common of_clk_init() function for clock initialization.
> > 
> > Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>
> 
> Pawel or Linus,
> 
> Can I get a Tested-by before I take this series into clk-next?

I'll just got back to work and will test it soon, most likely tomorrow.

Cheers!

Pawel


