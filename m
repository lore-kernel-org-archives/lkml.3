Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757700AbbA0IG3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 03:06:29 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:48275 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbbA0IG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 03:06:26 -0500
Date: Tue, 27 Jan 2015 00:06:25 -0800 (PST)
Message-Id: <20150127.000625.1477155165878386119.davem@davemloft.net>
To: vivien.didelot@savoirfairelinux.com
Cc: netdev@vger.kernel.org, linux@roeck-us.net, linux-kernel@vger.kernel.org,
        kernel@savoirfairelinux.com
Subject: Re: [PATCH] net: dsa/mv88e6352: make mv88e6352_wait generic
From: David Miller <davem@davemloft.net>
In-Reply-To: <1422056081-30088-1-git-send-email-vivien.didelot@savoirfairelinux.com>
References: <1422056081-30088-1-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 27 Jan 2015 00:06:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Date: Fri, 23 Jan 2015 18:34:41 -0500

> Some busy bits are available in the global register 1, such as the ATU
> Busy bit. We may want to use this function to wait for them to change,
> so add a new parameter to mv88e6352_wait() instead of hard-coding
> REG_GLOBAL2.
> 
> In the meantime, since the REG_READ() macro already checks for error,
> remove the redundant check for ret < 0.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>

Applied.
