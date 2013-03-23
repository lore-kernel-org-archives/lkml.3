Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab3CWX4y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 19:56:54 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35432 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab3CWX4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 19:56:53 -0400
Date: Sat, 23 Mar 2013 19:56:51 -0400 (EDT)
Message-Id: <20130323.195651.2270136988020869155.davem@davemloft.net>
To: gmate.amit@gmail.com
Cc: eilong@broadcom.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] bnx2x: fix assignment of signed expression to unsigned
 variable
From: David Miller <davem@davemloft.net>
In-Reply-To: <1364064775-19319-1-git-send-email-gmate.amit@gmail.com>
References: <1364064775-19319-1-git-send-email-gmate.amit@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Sat, 23 Mar 2013 16:56:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kumar Amit Mehta <gmate.amit@gmail.com>
Date: Sat, 23 Mar 2013 11:52:55 -0700

> fix for incorrect assignment of signed expression to unsigned variable.
> 
> Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>

Returning positive error codes is just as broken as what is there
currently.

These routines should return 0 or 1, the return value isn't even used
in any way, it is just tested against zero.
