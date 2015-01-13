Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbbAMW16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 17:27:58 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:36818 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbbAMW14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 17:27:56 -0500
Date: Tue, 13 Jan 2015 17:27:53 -0500 (EST)
Message-Id: <20150113.172753.83063003776927644.davem@davemloft.net>
To: rickard_strandqvist@spectrumdigital.se
Cc: jon.maloy@ericsson.com, allan.stephens@windriver.com,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tipc: link: Remove unused function
From: David Miller <davem@davemloft.net>
In-Reply-To: <1421173498-4012-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1421173498-4012-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 13 Jan 2015 14:27:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Tue, 13 Jan 2015 19:24:58 +0100

> Remove the function tipc_link_get_max_pkt() that is not used anywhere.
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

This does not apply to net-next.
