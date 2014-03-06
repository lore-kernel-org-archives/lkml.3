Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591AbaCFVdx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 16:33:53 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:33674 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463AbaCFVdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 16:33:51 -0500
Date: Thu, 06 Mar 2014 16:33:48 -0500 (EST)
Message-Id: <20140306.163348.942052862365762404.davem@davemloft.net>
To: doug.lkml@gmail.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] sparc64:tsb.c:use array size macro rather than
 number
From: David Miller <davem@davemloft.net>
In-Reply-To: <1393956248-9354-1-git-send-email-doug.lkml@gmail.com>
References: <1393956248-9354-1-git-send-email-doug.lkml@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Mar 2014 13:33:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Doug <doug.lkml@gmail.com>
Date: Tue,  4 Mar 2014 23:34:08 +0530

> This is a small patch which uses ARRAY_SIZE macro
> rather than a number to make code readability better.
> 
> Signed-off-by: Doug <doug.lkml@gmail.com>

Doug, please provide your full real-name, including your last
name, in your From: and Signoff.

Thank you.
