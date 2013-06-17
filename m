Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab3FQXTE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 19:19:04 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40309 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab3FQXTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 19:19:02 -0400
Date: Mon, 17 Jun 2013 16:19:01 -0700 (PDT)
Message-Id: <20130617.161901.1229542193546651097.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2013-06-17
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130617182719.GC2104@tuxdriver.com>
References: <20130617182719.GC2104@tuxdriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 17 Jun 2013 14:27:20 -0400

> This will probably be the last batch of wireless fixes intended
> for 3.10.  Many of these are one- or two-liners, and a couple of
> others are mostly relocating existing code to avoid races or to
> limit the code to effecting specific hardware, etc.

This looks fine even though the HT info fix is a bit sizable.

Pulled, thanks a lot.
