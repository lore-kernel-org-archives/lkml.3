Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbaADBiE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 20:38:04 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:35663 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235AbaADBiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 20:38:02 -0500
Date: Fri, 03 Jan 2014 20:37:59 -0500 (EST)
Message-Id: <20140103.203759.2168117129392277198.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next] r8152: fix the wrong return value
From: David Miller <davem@davemloft.net>
In-Reply-To: <1388719316-5702-1-git-send-email-hayeswang@realtek.com>
References: <1388719316-5702-1-git-send-email-hayeswang@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 03 Jan 2014 17:38:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Fri, 3 Jan 2014 11:21:56 +0800

> The return value should be the boolean value, not the error code.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> Spotted-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied, but I agree with others that it's more canonical to have the
function return either an error code, or zero for success, rather than
a boolean.
