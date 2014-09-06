Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751229AbaIFFVG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 01:21:06 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60006 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbaIFFUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 01:20:53 -0400
Date: Fri, 05 Sep 2014 22:20:50 -0700 (PDT)
Message-Id: <20140905.222050.386458461943550928.davem@davemloft.net>
To: colin.king@canonical.com
Cc: isdn@linux-pingi.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mISDN: remove DSP_NEVER_DEFINED and adjust code
 identation
From: David Miller <davem@davemloft.net>
In-Reply-To: <1409923571-28627-1-git-send-email-colin.king@canonical.com>
References: <1409923571-28627-1-git-send-email-colin.king@canonical.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 05 Sep 2014 22:20:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Fri,  5 Sep 2014 14:26:11 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> The DSP_NEVER_DEFINED #ifdef is confusing, it slips in an
> extra } which is not required because the previous code is
> indented incorrectly.  Correct the identation and remove the
> extraneous DSP_NEVER_DEFINED
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied to net-next, thanks.
