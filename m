Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbbAMW2d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 17:28:33 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:36834 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbbAMW2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 17:28:31 -0500
Date: Tue, 13 Jan 2015 17:28:29 -0500 (EST)
Message-Id: <20150113.172829.1548714500294830320.davem@davemloft.net>
To: rickard_strandqvist@spectrumdigital.se
Cc: chas@cmf.nrl.navy.mil, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atm: horizon: Remove some unused functions
From: David Miller <davem@davemloft.net>
In-Reply-To: <1421175021-6022-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1421175021-6022-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 13 Jan 2015 14:28:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Tue, 13 Jan 2015 19:50:21 +0100

> Removes some functions that are not used anywhere:
> channel_to_vpivci() query_tx_channel_config() rx_disabled_handler()
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Applied.
