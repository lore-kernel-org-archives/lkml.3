Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbaFKHPd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 03:15:33 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42961 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461AbaFKHPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 03:15:32 -0400
Date: Wed, 11 Jun 2014 00:15:31 -0700 (PDT)
Message-Id: <20140611.001531.1896504886716747190.davem@davemloft.net>
To: rickard_strandqvist@spectrumdigital.se
Cc: geoff@infradead.org, netdev@vger.kernel.org, cbe-oss-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: toshiba: ps3_gelic_net.c: Cleaning up a
 check on a memory allocation
From: David Miller <davem@davemloft.net>
In-Reply-To: <1402136528-16857-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1402136528-16857-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Jun 2014 00:15:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Sat,  7 Jun 2014 12:22:08 +0200

> A check on a memory allocation is checked incorrectly.
> 
> This was partly found using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Applied.
