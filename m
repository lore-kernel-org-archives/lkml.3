Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab3AWKyP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 05:54:15 -0500
Received: from service87.mimecast.com ([91.220.42.44]:51163 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672Ab3AWKyO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 05:54:14 -0500
Message-ID: <1358938451.26878.1.camel@hornet>
Subject: Re: [PATCH 7/7] clk: vexpress: Use common of_clk_init() function
From: Pawel Moll <pawel.moll@arm.com>
To: Prashant Gaikwad <pgaikwad@nvidia.com>
Cc: "mturquette@linaro.org" <mturquette@linaro.org>,
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
Date: Wed, 23 Jan 2013 10:54:11 +0000
In-Reply-To: <1357282858-2112-7-git-send-email-pgaikwad@nvidia.com>
References: <1357282858-2112-1-git-send-email-pgaikwad@nvidia.com>
	 <1357282858-2112-7-git-send-email-pgaikwad@nvidia.com>
X-Mailer: Evolution 3.6.2-0ubuntu0.1
Mime-Version: 1.0
X-OriginalArrivalTime: 23 Jan 2013 10:54:11.0947 (UTC) FILETIME=[FA3E4BB0:01CDF957]
X-MC-Unique: 113012310541204601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-01-04 at 07:00 +0000, Prashant Gaikwad wrote:
> Use common of_clk_init() function for clock initialization.
> 
> Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>

Just tested on VE, looks good to me.

So for this patch and the "[1/7] clk: add common of_clk_init() function"
one:

Tested-by: Pawel Moll <pawel.moll@arm.com>

Cheers!

Pawel


