Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646AbbALWC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 17:02:27 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:54548 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbbALWCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 17:02:25 -0500
Date: Mon, 12 Jan 2015 17:02:22 -0500 (EST)
Message-Id: <20150112.170222.1860658499018127066.davem@davemloft.net>
To: rickard_strandqvist@spectrumdigital.se
Cc: steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: xfrm: xfrm_algo: Remove unused function
From: David Miller <davem@davemloft.net>
In-Reply-To: <1420981415-16343-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1420981415-16343-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 12 Jan 2015 14:02:25 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Sun, 11 Jan 2015 14:03:35 +0100

> Remove the function aead_entries() that is not used anywhere.
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Applied.
