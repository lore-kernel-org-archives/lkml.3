Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbaESB0a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 21:26:30 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44451 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbaESB03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 21:26:29 -0400
Date: Sun, 18 May 2014 21:26:28 -0400 (EDT)
Message-Id: <20140518.212628.857663264573601256.davem@davemloft.net>
To: rickard_strandqvist@spectrumdigital.se
Cc: cascardo@linux.vnet.ibm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: ibm: ehea: ehea_qmr.c: Fix for possible
 null pointer dereference
From: David Miller <davem@davemloft.net>
In-Reply-To: <1400428881-10310-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1400428881-10310-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 18 May 2014 18:26:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Sun, 18 May 2014 18:01:21 +0200

> There is otherwise a risk of a possible null pointer dereference.
> 
> Was largely found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Applied, thanks.
