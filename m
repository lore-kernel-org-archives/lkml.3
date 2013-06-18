Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab3FRALp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 20:11:45 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40802 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab3FRALo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 20:11:44 -0400
Date: Mon, 17 Jun 2013 17:11:41 -0700 (PDT)
Message-Id: <20130617.171141.1129703356005827268.davem@davemloft.net>
To: linus.luessing@web.de
Cc: bridge@lists.linux-foundation.org, stephen@networkplumber.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bridge: fix switched interval for MLD Query types
From: David Miller <davem@davemloft.net>
In-Reply-To: <1371417634-29803-1-git-send-email-linus.luessing@web.de>
References: <1371417634-29803-1-git-send-email-linus.luessing@web.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Lüssing <linus.luessing@web.de>
Date: Sun, 16 Jun 2013 23:20:34 +0200

> General Queries (the one with the Multicast Address field
> set to zero / '::') are supposed to have a Maximum Response Delay
> of [Query Response Interval], while for Multicast-Address-Specific
> Queries it is [Last Listener Query Interval] - not the other way
> round. (see RFC2710, section 7.3+7.8)
> 
> Signed-off-by: Linus Lüssing <linus.luessing@web.de>

Applied, thanks.
