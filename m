Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523AbaEIUef (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 16:34:35 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39480 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757439AbaEIUed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 16:34:33 -0400
Date: Fri, 09 May 2014 16:34:31 -0400 (EDT)
Message-Id: <20140509.163431.2271871004754320745.davem@davemloft.net>
To: emilgoode@gmail.com
Cc: jg1.han@samsung.com, jeffrey.t.kirsher@intel.com, ben@decadent.org.uk,
        arend@broadcom.com, joe@perches.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net: cassini: use nested lock annotation
From: David Miller <davem@davemloft.net>
In-Reply-To: <1399590437-5548-1-git-send-email-emilgoode@gmail.com>
References: <1399590437-5548-1-git-send-email-emilgoode@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 09 May 2014 13:34:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emil Goode <emilgoode@gmail.com>
Date: Fri,  9 May 2014 01:07:17 +0200

> In the cas_lock_tx function we acquire multiple locks in a loop and
> need to use nested lock annotation to prevent lockdep warnings.
> 
> Reported-by: Meelis Roos <mroos@linux.ee>
> Signed-off-by: Emil Goode <emilgoode@gmail.com>

Applied, thanks.
