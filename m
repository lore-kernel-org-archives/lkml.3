Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574AbbABVkQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 16:40:16 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:53829 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbbABVkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 16:40:11 -0500
Date: Fri, 02 Jan 2015 16:40:09 -0500 (EST)
Message-Id: <20150102.164009.2208912516300295493.davem@davemloft.net>
To: rickard_strandqvist@spectrumdigital.se
Cc: isdn@linux-pingi.de, dan.carpenter@oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] isdn: hisax: hfc4s8s_l1: Remove some unused functions
From: David Miller <davem@davemloft.net>
In-Reply-To: <1420139842-3573-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1420139842-3573-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 02 Jan 2015 13:40:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Thu,  1 Jan 2015 20:17:22 +0100

> Removes some functions that are not used anywhere:
> Read_hfc32() Write_hfc32() Write_hfc16()
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Applied.
