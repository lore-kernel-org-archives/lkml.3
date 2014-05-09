Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757681AbaEIUrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 16:47:17 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39536 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757654AbaEIUrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 16:47:15 -0400
Date: Fri, 09 May 2014 16:47:13 -0400 (EDT)
Message-Id: <20140509.164713.1131802723098415051.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2014-05-08
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140508152516.GC6180@tuxdriver.com>
References: <20140508152516.GC6180@tuxdriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 09 May 2014 13:47:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 8 May 2014 11:25:17 -0400

> This one is all from Johannes:
> 
> "Here are a few small fixes for the current cycle: radiotap TX flags were
> wrong (fix by Bob), Chun-Yeow fixes an SMPS issue with mesh interfaces,
> Eliad fixes a locking bug and a cfg80211 state problem and finally
> Henning sent me a fix for IBSS rate information."
> 
> Please let me know if there are problems!

Pulled, thanks John.
