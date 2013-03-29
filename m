Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab3C2SiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 14:38:24 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55757 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756509Ab3C2SiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 14:38:13 -0400
Date: Fri, 29 Mar 2013 14:38:08 -0400 (EDT)
Message-Id: <20130329.143808.647821389772332250.davem@davemloft.net>
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
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Fri, 29 Mar 2013 11:38:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kirill Kapranov <kapranoff@inbox.ru>
Date: Tue, 26 Mar 2013 17:34:32 +0400

> In case of fixed speed set up for a NIC (e.g. ethtool -s eth0 autoneg off speed
> 100 duplex full) with an ethernet cable plugged off, the mentioned algorithm
> slows down a NIC speed, so further cable hook-up leads to nonoperable link state.
> 
> Signed-off-by: Kirill Kapranov <kapranoff@inbox.ru>

Why are you posting this again?  I've applied your patch 3 days
ago.
