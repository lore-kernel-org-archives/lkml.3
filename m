Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448AbaCQT4K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 15:56:10 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42209 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaCQT4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 15:56:08 -0400
Date: Mon, 17 Mar 2014 15:56:06 -0400 (EDT)
Message-Id: <20140317.155606.2293125630270390078.davem@davemloft.net>
To: doug.lkml@gmail.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] sparc64:tsb.c:use array size macro rather than
 number
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394189943-6012-1-git-send-email-doug.lkml@gmail.com>
References: <1394189943-6012-1-git-send-email-doug.lkml@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Mar 2014 12:56:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Doug <doug.lkml@gmail.com>
Date: Fri,  7 Mar 2014 16:29:03 +0530

> From: Doug Wilson <doug.lkml@gmail.com>
> 
>     This is a small patch which uses ARRAY_SIZE macro
>     rather than a number to make code readability better.
> 
> Signed-off-by: Doug Wilson <doug.lkml@gmail.com>

Applied, thanks Doug.
