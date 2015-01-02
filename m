Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423AbbABVj6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 16:39:58 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:53824 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbbABVj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 16:39:57 -0500
Date: Fri, 02 Jan 2015 16:39:54 -0500 (EST)
Message-Id: <20150102.163954.1550479595529880647.davem@davemloft.net>
To: rickard_strandqvist@spectrumdigital.se
Cc: santosh@chelsio.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: chelsio: cxgb3: mc5.c: Remove some
 unused functions
From: David Miller <davem@davemloft.net>
In-Reply-To: <1420130996-29910-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1420130996-29910-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 02 Jan 2015 13:39:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Thu,  1 Jan 2015 17:49:55 +0100

> Removes some functions that are not used anywhere:
> dbgi_rd_rsp3() dbgi_wr_addr3()
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Applied.
