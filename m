Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936145Ab3DINuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 09:50:17 -0400
Received: from mx17.lb01.inode.at ([62.99.145.19]:53699 "EHLO mx.inode.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756358Ab3DINtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 09:49:40 -0400
X-Greylist: delayed 19362 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Apr 2013 09:49:39 EDT
From: Michal Bachraty <michal.bachraty@streamunlimited.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        mturquette@linaro.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clk: si5351: Add gapless tuning for SI5351 PLL
Date: Tue, 09 Apr 2013 15:49:37 +0200
Message-ID: <2031033.gNGydvIeAk@ganymedes>
Organization: Stream Unlimited GmbH
User-Agent: KMail/4.8.4 (Linux/3.2.0-29-generic-pae; KDE/4.8.4; i686; ; )
In-Reply-To: <CABJ1b_RW=UUxmTrYOsx2wsDm1egs9DL3dWtat0--5kqec9-rQA@mail.gmail.com>
References: <1365495975-792-1-git-send-email-michal.bachraty@streamunlimited.com> <CABJ1b_RW=UUxmTrYOsx2wsDm1egs9DL3dWtat0--5kqec9-rQA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Authenticated-Sender: michal.bachraty@streamunlimited.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

> does gapless tuning have any constraints? Can we use it for all rate
> changes or determine the
> need for pll reset by rate offset?

Today I made some test measurements ( switching from 22.5MHz to 32kHz, then to 
50MHz, then to 1MHz) with good results: without any gaps and any side 
frequences.  So there are no constrains, and we can use it for any frequences. 

Best,
Michal

