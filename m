Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbaHKT2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 15:28:21 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58370 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbaHKT2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 15:28:20 -0400
Date: Mon, 11 Aug 2014 12:28:18 -0700 (PDT)
Message-Id: <20140811.122818.193540699184570884.davem@davemloft.net>
To: rickard_strandqvist@spectrumdigital.se
Cc: florian@openwrt.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: ti: cpmac.c: Cleaning up missing
 null-terminate after strncpy call
From: David Miller <davem@davemloft.net>
In-Reply-To: <1407627707-24303-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1407627707-24303-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 11 Aug 2014 12:28:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Sun, 10 Aug 2014 01:41:47 +0200

> Added a guaranteed null-terminate after call to strncpy.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Applied.
