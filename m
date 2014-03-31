Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363AbaCaVJ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 17:09:57 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43366 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaCaVJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 17:09:55 -0400
Date: Mon, 31 Mar 2014 17:09:53 -0400 (EDT)
Message-Id: <20140331.170953.1487229969639485446.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-next 2014-03-31
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140331193118.GE17412@tuxdriver.com>
References: <20140331193118.GE17412@tuxdriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 31 Mar 2014 14:09:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 31 Mar 2014 15:31:19 -0400

> Please accept this one last round of general wireless updates for
> the 3.15 merge window!
> 
> For the Bluetooth bits, Gustavo says:
> 
> "Here follow another set of patches to 3.15. This is mostly a bug fix
> pull request with the exception of one commit from Marcel which adds
> tracking to the current configured LE scan type parameter."
> 
> Beyond that, notable bits include some final refactoring of rtl8180
> and the addition of the rtl8187se driver, fixes for a number of
> problems identified by Dan Carpenter and his static analysis tools,
> and a handful of other bits here and there.
> 
> Please let me know if there are problems!

Pulled, thanks John.
