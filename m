Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751286AbaJATeh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 15:34:37 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35761 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbaJATeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 15:34:36 -0400
Date: Wed, 01 Oct 2014 15:34:34 -0400 (EDT)
Message-Id: <20141001.153434.1528027414789643819.davem@davemloft.net>
To: hau@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next 01/10] r8169:change uppercase number to
 lowercase nubmer
From: David Miller <davem@davemloft.net>
In-Reply-To: <1412176641-24393-1-git-send-email-hau@realtek.com>
References: <1412176641-24393-1-git-send-email-hau@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 Oct 2014 12:34:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chun-Hao Lin <hau@realtek.com>
Date: Wed, 1 Oct 2014 23:17:12 +0800

> Signed-off-by: Chun-Hao Lin <hau@realtek.com>

Series applied, and I fixed the typo in the Subject line here.

But you _(REALLY)_ need to provide a [PATCH net-next 00/xx] posting at
the beginning of the patch series which gives an overview of what the
patch series does at a high level, and why.

This also allows me to have a sensible post to reply to when I just
need to say what I've done with the entire series rather than
providing comments on a specific patch.

Thanks.
