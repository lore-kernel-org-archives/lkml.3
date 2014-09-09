Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046AbaIIXi0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 19:38:26 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33827 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962AbaIIXiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 19:38:24 -0400
Date: Tue, 09 Sep 2014 16:38:23 -0700 (PDT)
Message-Id: <20140909.163823.1969878759983159404.davem@davemloft.net>
To: andreas@gaisler.com
Cc: sparclinux@vger.kernel.org, sam@ravnborg.org, linux-kernel@vger.kernel.org,
        software@gaisler.com
Subject: Re: [PATCH] sparc: Let memset return the address argument
From: David Miller <davem@davemloft.net>
In-Reply-To: <1409324901-19291-1-git-send-email-andreas@gaisler.com>
References: <1409324901-19291-1-git-send-email-andreas@gaisler.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Sep 2014 16:38:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Larsson <andreas@gaisler.com>
Date: Fri, 29 Aug 2014 17:08:21 +0200

> This makes memset follow the standard (instead of returning 0 on success). This
> is needed when certain versions of gcc optimizes around memset calls and assume
> that the address argument is preserved in %o0.
> 
> Signed-off-by: Andreas Larsson <andreas@gaisler.com>

Applied, thanks Andreas.
