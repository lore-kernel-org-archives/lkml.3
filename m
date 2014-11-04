Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbaKDUKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 15:10:53 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:58850 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbaKDUKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 15:10:51 -0500
Date: Tue, 04 Nov 2014 15:10:49 -0500 (EST)
Message-Id: <20141104.151049.2195891686952455155.davem@davemloft.net>
To: fabf@skynet.be
Cc: linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1 net-next] cipso: remove NULL assignment on static
From: David Miller <davem@davemloft.net>
In-Reply-To: <1415128759-11264-1-git-send-email-fabf@skynet.be>
References: <1415128759-11264-1-git-send-email-fabf@skynet.be>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Nov 2014 12:10:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>
Date: Tue,  4 Nov 2014 20:19:19 +0100

> Also add blank line after structure declarations
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Applied.
