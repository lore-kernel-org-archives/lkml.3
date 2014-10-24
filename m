Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901AbaJXEnm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 00:43:42 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46406 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaJXEnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 00:43:41 -0400
Date: Fri, 24 Oct 2014 00:43:39 -0400 (EDT)
Message-Id: <20141024.004339.2194585987132577011.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cirrus/mac89x0: Remove superfluous interrupt
 disable/restore
From: David Miller <davem@davemloft.net>
In-Reply-To: <1413913991-23634-1-git-send-email-geert@linux-m68k.org>
References: <1413913991-23634-1-git-send-email-geert@linux-m68k.org>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Oct 2014 21:43:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 21 Oct 2014 19:53:11 +0200

> As of commit e4dc601bf99ccd1c ("m68k: Disable/restore interrupts in
> hwreg_present()/hwreg_write()"), this is no longer needed.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Applied.
