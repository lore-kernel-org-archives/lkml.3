Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352AbaJ0UE0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 16:04:26 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50509 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbaJ0UEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 16:04:23 -0400
Date: Mon, 27 Oct 2014 16:04:21 -0400 (EDT)
Message-Id: <20141027.160421.346832095714086308.davem@davemloft.net>
To: fabf@skynet.be
Cc: linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] ipv4: remove set but unused variable sha
From: David Miller <davem@davemloft.net>
In-Reply-To: <1414433002-29106-1-git-send-email-fabf@skynet.be>
References: <1414433002-29106-1-git-send-email-fabf@skynet.be>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Oct 2014 13:04:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>
Date: Mon, 27 Oct 2014 19:03:22 +0100

> unsigned char *sha (source) was already in original git version
>  but was never used.
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Applied.
