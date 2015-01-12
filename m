Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbbALWCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 17:02:33 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:54553 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbbALWCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 17:02:31 -0500
Date: Mon, 12 Jan 2015 17:02:29 -0500 (EST)
Message-Id: <20150112.170229.2277590143144424652.davem@davemloft.net>
To: rickard_strandqvist@spectrumdigital.se
Cc: jhs@mojatatu.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sched: sch_teql: Remove unused function
From: David Miller <davem@davemloft.net>
In-Reply-To: <1420985326-18201-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1420985326-18201-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 12 Jan 2015 14:02:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Sun, 11 Jan 2015 15:08:46 +0100

> Remove the function teql_neigh_release() that is not used anywhere.
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Applied.
