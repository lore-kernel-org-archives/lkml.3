Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbbABVkG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 16:40:06 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:53826 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbbABVkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 16:40:02 -0500
Date: Fri, 02 Jan 2015 16:40:00 -0500 (EST)
Message-Id: <20150102.164000.1127873983127267720.davem@davemloft.net>
To: rickard_strandqvist@spectrumdigital.se
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: fddi: skfp: smt.c: Remove unused function
From: David Miller <davem@davemloft.net>
In-Reply-To: <1420131686-30895-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1420131686-30895-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 02 Jan 2015 13:40:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Thu,  1 Jan 2015 18:01:26 +0100

> Remove the function smt_ifconfig() that is not used anywhere.
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Applied.
