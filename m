Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbaKDULN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 15:11:13 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:58863 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbaKDULI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 15:11:08 -0500
Date: Tue, 04 Nov 2014 15:11:06 -0500 (EST)
Message-Id: <20141104.151106.128272404545684471.davem@davemloft.net>
To: fabf@skynet.be
Cc: linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1 net-next] ipv4: use seq_puts instead of seq_printf
 where possible
From: David Miller <davem@davemloft.net>
In-Reply-To: <1415129486-13185-1-git-send-email-fabf@skynet.be>
References: <1415129486-13185-1-git-send-email-fabf@skynet.be>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Nov 2014 12:11:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>
Date: Tue,  4 Nov 2014 20:31:26 +0100

> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Applied.
