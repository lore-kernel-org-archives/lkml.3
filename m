Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827Ab3GXJb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 05:31:28 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55371 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab3GXJb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 05:31:27 -0400
Date: Wed, 24 Jul 2013 02:31:26 -0700 (PDT)
Message-Id: <20130724.023126.792508581970927723.davem@davemloft.net>
To: cmetcalf@tilera.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 01/13] tile: handle 64-bit statistics in tilepro
 network driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <40362053a9f02d56a4f0c07a9982d96203723ec8.1374609948.git.cmetcalf@tilera.com>
References: <cover.1374609948.git.cmetcalf@tilera.com>
	<40362053a9f02d56a4f0c07a9982d96203723ec8.1374609948.git.cmetcalf@tilera.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 24 Jul 2013 02:31:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 23 Jul 2013 16:05:48 -0400

> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>

I'm pretty sure that you need to make use of the primitives in
include/linux/u64_stats_sync.h if you want to use 64-bit statistics
in this way.

