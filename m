Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945Ab3C2Tky (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 15:40:54 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56519 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756641Ab3C2Tkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 15:40:53 -0400
Date: Fri, 29 Mar 2013 15:40:51 -0400 (EDT)
Message-Id: <20130329.154051.48484741575211147.davem@davemloft.net>
To: pebolle@tiscali.nl
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cirrus: cs89x0: remove two obsolete Kconfig macros
From: David Miller <davem@davemloft.net>
In-Reply-To: <1364554290.1345.52.camel@x61.thuisdomein>
References: <1364554290.1345.52.camel@x61.thuisdomein>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Fri, 29 Mar 2013 12:40:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Bolle <pebolle@tiscali.nl>
Date: Fri, 29 Mar 2013 11:51:30 +0100

> The CONFIG_ARCH_IXDP2X01 and CONFIG_MACH_IXDP2351 Kconfig macros are
> unused since the ixp23xx and ixp2000 platforms were removed in v3.5. So
> remove the last code still depending on these macros. And since
> CS89x0_NONISA_IRQ was only set if either of these two macros was defined
> we can also remove that macro and the code depending on it.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Applied, thanks Paul.
