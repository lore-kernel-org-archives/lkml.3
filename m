Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786AbaIISqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 14:46:48 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59530 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbaIISqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 14:46:46 -0400
Date: Tue, 09 Sep 2014 11:46:45 -0700 (PDT)
Message-Id: <20140909.114645.1318455090986185477.davem@davemloft.net>
To: ricardo.ribalda@gmail.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH 3/3 v2] sparc/uapi: Add definition of TIOC[SG]RS485
From: David Miller <davem@davemloft.net>
In-Reply-To: <1410287879-2368-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1410287879-2368-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Sep 2014 11:46:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Tue,  9 Sep 2014 20:37:59 +0200

> Commit: e676253b19b2d269cccf67fdb1592120a0cd0676 (serial/8250: Add
> support for RS485 IOCTLs), adds support for RS485 ioctls for 825_core on
> all the archs. Unfortunaltely the definition of TIOCSRS485 and
> TIOCGRS485 was missing on the ioctls.h file
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

Acked-by: David S. Miller <davem@davemloft.net>
