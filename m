Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126Ab3CZQ7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 12:59:18 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41274 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab3CZQ7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 12:59:15 -0400
Date: Tue, 26 Mar 2013 12:59:13 -0400 (EDT)
Message-Id: <20130326.125913.1596841088076065473.davem@davemloft.net>
To: kapranoff@inbox.ru
Cc: netdev@vger.kernel.org, bhutchings@solarflare.com, peppe.cavallaro@st.com,
        joe@perches.com, bruce.w.allan@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] phy: Elimination the forced speed reduction algorithm.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1364304872-6408-1-git-send-email-kapranoff@inbox.ru>
References: <1364304872-6408-1-git-send-email-kapranoff@inbox.ru>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 26 Mar 2013 09:59:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kirill Kapranov <kapranoff@inbox.ru>
Date: Tue, 26 Mar 2013 17:34:32 +0400

> -					phy_force_reduction(phydev);
> +				if (0 == phydev->link_timeout--) 
                                                                ^^^^

Trailing whitespace, please remove.

Also, for whatever reason this patch didn't make it to the mailing
list, that's critical because we automate the tracking of patches by
catching the patch postings made to the list.
