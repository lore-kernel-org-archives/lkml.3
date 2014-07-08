Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbaGHXGp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 19:06:45 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54898 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaGHXGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 19:06:44 -0400
Date: Tue, 08 Jul 2014 16:06:43 -0700 (PDT)
Message-Id: <20140708.160643.2062728280845180381.davem@davemloft.net>
To: rickard_strandqvist@spectrumdigital.se
Cc: isdn@linux-pingi.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] isdn: hisax: l3ni1.c: Fix for possible null pointer
 dereference
From: David Miller <davem@davemloft.net>
In-Reply-To: <1404648277-12419-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1404648277-12419-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 08 Jul 2014 16:06:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Sun,  6 Jul 2014 14:04:37 +0200

> There is otherwise a risk of a possible null pointer dereference.
> 
> Was largely found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Applied, thanks.
