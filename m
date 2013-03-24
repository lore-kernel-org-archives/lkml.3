Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118Ab3CXV2Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 17:28:16 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44005 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706Ab3CXV2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 17:28:14 -0400
Date: Sun, 24 Mar 2013 17:28:13 -0400 (EDT)
Message-Id: <20130324.172813.1125045357453229626.davem@davemloft.net>
To: gmate.amit@gmail.com
Cc: eilong@broadcom.com, dan.carpenter@oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] bnx2x: fix assignment of signed expression to
 unsigned variable
From: David Miller <davem@davemloft.net>
In-Reply-To: <1364105425-8198-1-git-send-email-gmate.amit@gmail.com>
References: <1364105425-8198-1-git-send-email-gmate.amit@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Sun, 24 Mar 2013 14:28:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kumar Amit Mehta <gmate.amit@gmail.com>
Date: Sat, 23 Mar 2013 23:10:25 -0700

> fix for incorrect assignment of signed expression to unsigned variable.
> 
> Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>

Applied.
