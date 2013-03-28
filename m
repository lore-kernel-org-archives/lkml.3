Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab3C1S2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 14:28:16 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44180 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab3C1S2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 14:28:15 -0400
Date: Thu, 28 Mar 2013 14:28:05 -0400 (EDT)
Message-Id: <20130328.142805.1513763085962415952.davem@davemloft.net>
To: honkiko@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stephen@networkplumber.org, tgraf@suug.ch
Subject: Re: [PATCH 1/6] net-next: replace obsolete NLMSG_* with type safe
 nlmsg_*
From: David Miller <davem@davemloft.net>
In-Reply-To: <1364402824-32680-1-git-send-email-honkiko@gmail.com>
References: <1364402824-32680-1-git-send-email-honkiko@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Thu, 28 Mar 2013 11:28:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hong Zhiguo <honkiko@gmail.com>
Date: Thu, 28 Mar 2013 00:47:04 +0800

> Signed-off-by: Hong Zhiguo <honkiko@gmail.com>

Applied with formatting fixes up in nlmsg_alloc() calls.
