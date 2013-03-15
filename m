Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab3COMvV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 08:51:21 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46932 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167Ab3COMvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 08:51:20 -0400
Date: Fri, 15 Mar 2013 08:51:35 -0400 (EDT)
Message-Id: <20130315.085135.1979138622322564611.davem@davemloft.net>
To: joe@perches.com
Cc: kapranoff@inbox.ru, netdev@vger.kernel.org, bhutchings@solarflare.com,
        peppe.cavallaro@st.com, bruce.w.allan@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] phy: Elimination the forced speed reduction algorithm.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1363351729.2433.4.camel@joe-AO722>
References: <1363257652-8255-1-git-send-email-kapranoff@inbox.ru>
	<20130315.083524.1244515166306242265.davem@davemloft.net>
	<1363351729.2433.4.camel@joe-AO722>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Fri, 15 Mar 2013 05:51:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Fri, 15 Mar 2013 05:48:49 -0700

> The phy code also uses non standard kernel style tests like
> 	if (CONSTANT == variable)
> instead of
> 	if (variable == CONSTANT)

Right, to trigger compile time errors when "=" is accidently used
instead of "==".

But the whole driver is like this already.
