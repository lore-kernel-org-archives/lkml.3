Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656AbaHYWNi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 18:13:38 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38382 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168AbaHYWNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 18:13:37 -0400
Date: Mon, 25 Aug 2014 15:13:32 -0700 (PDT)
Message-Id: <20140825.151332.884666922271843083.davem@davemloft.net>
To: pavel@ucw.cz
Cc: peppe.cavallaro@st.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH for -next] stmmac: simple cleanups
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140825113116.GA21632@amd>
References: <20140819105646.GA27984@amd>
	<20140822.123408.2064974279443073401.davem@davemloft.net>
	<20140825113116.GA21632@amd>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 25 Aug 2014 15:13:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Machek <pavel@ucw.cz>
Date: Mon, 25 Aug 2014 13:31:16 +0200

> This adds simple cleanups for stmmac, removing test we know is always
> true, fixing whitespace, and moving code out of if().
> 
> Signed-off-by: Pavel Machek <pavel@denx.de>

Applied, thanks.
