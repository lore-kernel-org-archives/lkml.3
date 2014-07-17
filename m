Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbaGQGPX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 02:15:23 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57660 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387AbaGQGPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 02:15:20 -0400
Date: Wed, 16 Jul 2014 23:15:20 -0700 (PDT)
Message-Id: <20140716.231520.464767705887484308.davem@davemloft.net>
To: varkabhadram@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, varkab@cdac.in
Subject: Re: [PATCH net-next] netlink: remove bool varible
From: David Miller <davem@davemloft.net>
In-Reply-To: <1405488587-26119-1-git-send-email-varkabhadram@gmail.com>
References: <1405488587-26119-1-git-send-email-varkabhadram@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 16 Jul 2014 23:15:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: varkabhadram@gmail.com
Date: Wed, 16 Jul 2014 10:59:47 +0530

> From: Varka Bhadram <varkab@cdac.in>
> 
> This patch removes the bool variable 'pass'.
> If the swith case exist return true or return false.
> 
> Signed-off-by: Varka Bhadram <varkab@cdac.in>

This is fine, applied, thanks.
