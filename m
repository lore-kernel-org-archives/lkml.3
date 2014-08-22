Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932945AbaHVScA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 14:32:00 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52956 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932410AbaHVSb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 14:31:59 -0400
Date: Fri, 22 Aug 2014 11:31:58 -0700 (PDT)
Message-Id: <20140822.113158.256044299285972431.davem@davemloft.net>
To: linux@rasmusvillemoes.dk
Cc: mac@melware.de, isdn@linux-pingi.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: isdn: eicon: xdi_msg.h: Fix typo in #ifndef
From: David Miller <davem@davemloft.net>
In-Reply-To: <1408725554-2524-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1408725554-2524-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 Aug 2014 11:31:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Date: Fri, 22 Aug 2014 18:39:14 +0200

> Test for definedness of the macro which is actually defined (the
> change is hard to see: it is s/SSS/SSA/).
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Applied.
