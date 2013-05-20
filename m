Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007Ab3ETHUf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 03:20:35 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54663 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374Ab3ETHUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 03:20:34 -0400
Date: Mon, 20 May 2013 00:20:33 -0700 (PDT)
Message-Id: <20130520.002033.188756467952679642.davem@davemloft.net>
To: eike-kernel@sf-tec.de
Cc: chessman@tux.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ThunderLAN: remove is_eisa flag
From: David Miller <davem@davemloft.net>
In-Reply-To: <3469605.xkLC7l46TH@eto>
References: <3469605.xkLC7l46TH@eto>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Mon, 20 May 2013 00:20:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Date: Sat, 18 May 2013 23:50:17 +0200

> These 2 places are the only matches for is_eisa in the whole tree.
> 
> Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>

Applied, thanks.
