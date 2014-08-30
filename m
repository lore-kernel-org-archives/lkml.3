Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373AbaH3Dd7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 23:33:59 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52893 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaH3Dd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 23:33:58 -0400
Date: Fri, 29 Aug 2014 20:33:57 -0700 (PDT)
Message-Id: <20140829.203357.1929663716118629035.davem@davemloft.net>
To: linux@rasmusvillemoes.dk
Cc: paul.gortmaker@windriver.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Remove various orphaned header files
From: David Miller <davem@davemloft.net>
In-Reply-To: <1409226274-3202-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1409226274-3202-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 29 Aug 2014 20:33:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Date: Thu, 28 Aug 2014 13:44:30 +0200

> These four files are not included anywhere, and seem to be accidental
> leftovers from past cleanups (see the individual commit messages).

Series applied, thanks.
