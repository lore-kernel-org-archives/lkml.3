Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbaIOSRf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 14:17:35 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35958 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462AbaIOSRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 14:17:33 -0400
Date: Mon, 15 Sep 2014 14:17:27 -0400 (EDT)
Message-Id: <20140915.141727.73988373928852130.davem@davemloft.net>
To: rickard_strandqvist@spectrumdigital.se
Cc: grant.likely@linaro.org, robh+dt@kernel.org, B38611@freescale.com,
        rmk+kernel@arm.linux.org.uk, fabio.estevam@freescale.com,
        frank.li@freescale.com, u.kleine-koenig@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: freescale: fec_main.c: Cleaning up
 missing null-terminate in conjunction with strncpy
From: David Miller <davem@davemloft.net>
In-Reply-To: <1410715962-15986-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1410715962-15986-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 15 Sep 2014 11:17:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Sun, 14 Sep 2014 19:32:42 +0200

> Replacing strncpy with strlcpy to avoid strings that lacks null terminate.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Applied.
