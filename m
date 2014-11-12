Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbaKLRnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 12:43:41 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:44521 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998AbaKLRnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 12:43:40 -0500
Date: Wed, 12 Nov 2014 12:43:33 -0500 (EST)
Message-Id: <20141112.124333.526512550325097947.davem@davemloft.net>
To: M.Stam@fugro.nl
Cc: ben@decadent.org.uk, ckeepax@opensource.wolfsonmicro.com,
        riku.voipio@iki.fi, linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Subject: Re: "asix: Don't reset PHY on if_up for ASIX 88772" breaks net on
 arndale platform
From: David Miller <davem@davemloft.net>
In-Reply-To: <C89EFD3CD56F64468D3D206D683A8D2203A003FE@ldam-msx2.fugro-nl.local>
References: <20141104200914.GN23178@opensource.wolfsonmicro.com>
	<1415751802.3398.107.camel@decadent.org.uk>
	<C89EFD3CD56F64468D3D206D683A8D2203A003FE@ldam-msx2.fugro-nl.local>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Nov 2014 09:43:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please do not top-post.
