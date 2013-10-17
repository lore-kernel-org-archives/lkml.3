Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762693Ab3JQUFE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 16:05:04 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46791 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756787Ab3JQUFB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 16:05:01 -0400
Date: Thu, 17 Oct 2013 16:04:59 -0400 (EDT)
Message-Id: <20131017.160459.1507161094032710327.davem@davemloft.net>
To: GKelleter@datus.com
Cc: andrew.hendry@gmail.com, linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] X.25: Fix address field length calculation
From: David Miller <davem@davemloft.net>
In-Reply-To: <525D5131.9070007@datus.com>
References: <525D5131.9070007@datus.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 17 Oct 2013 13:05:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kelleter, Günther <GKelleter@datus.com>
Date: Tue, 15 Oct 2013 14:29:06 +0000

> Addresses are BCD encoded, not ASCII. x25_addr_ntoa got it right.
> 
> Signed-off-by: Guenther Kelleter <gkelleter@datus.com>
> ---
> Wrong length calculation leads to rejection of CALL ACCEPT packets.

This patch doesn't apply because it was severely corrupted by your
email client, turn off all encodings etc. in your client, send
a test patch to yourself, and do not submit this patch again until
you can successfully apply the patch you receive in those test emails.

Thanks.
