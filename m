Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571AbaLaTPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 14:15:31 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:45211 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbaLaTPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 14:15:30 -0500
Date: Wed, 31 Dec 2014 14:15:19 -0500 (EST)
Message-Id: <20141231.141519.1699158219787680373.davem@davemloft.net>
To: agartrell@fb.com
Cc: herbert@gondor.apana.org.au, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH net-next] tun: Fixed unsigned/signed comparison
From: David Miller <davem@davemloft.net>
In-Reply-To: <1419577503-12862-1-git-send-email-agartrell@fb.com>
References: <1419577503-12862-1-git-send-email-agartrell@fb.com>
X-Mailer: Mew version 6.6 on Emacs 24.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 31 Dec 2014 11:15:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Gartrell <agartrell@fb.com>
Date: Thu, 25 Dec 2014 23:05:03 -0800

> Validated that this was actually using the unsigned comparison with gdb.
> 
> Signed-off-by: Alex Gartrell <agartrell@fb.com>

Applied.
