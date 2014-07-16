Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934090AbaGPFZN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 01:25:13 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47582 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973AbaGPFZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 01:25:09 -0400
Date: Tue, 15 Jul 2014 22:25:06 -0700 (PDT)
Message-Id: <20140715.222506.441840340242813808.davem@davemloft.net>
To: varkabhadram@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, varkab@cdac.in
Subject: Re: [PATCH net-next] netlink: fix in netlink_filter_tap
From: David Miller <davem@davemloft.net>
In-Reply-To: <1405487844-25969-1-git-send-email-varkabhadram@gmail.com>
References: <1405487844-25969-1-git-send-email-varkabhadram@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 15 Jul 2014 22:25:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: varkabhadram@gmail.com
Date: Wed, 16 Jul 2014 10:47:24 +0530

> From: Varka Bhadram <varkab@cdac.in>
> 
> Remove the bool variable 'pass'. Return the true/false directly.
> 
> Signed-off-by: Varka Bhadram <varkab@cdac.in>

This doesn't "fix" anything, it's a cleanup.

Please resubmit this with a more correct commit header line and
commit message.
