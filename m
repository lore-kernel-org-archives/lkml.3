Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab3GITup (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 15:50:45 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58810 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab3GITuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 15:50:40 -0400
Date: Tue, 09 Jul 2013 12:50:40 -0700 (PDT)
Message-Id: <20130709.125040.1834646995344159799.davem@davemloft.net>
To: nicolas.ferre@atmel.com
Cc: neidhard.kim@lge.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] net/cadence/macb: fix bug/typo in extracting
 gem_irq_read_clear bit
From: David Miller <davem@davemloft.net>
In-Reply-To: <51DC340F.2060402@atmel.com>
References: <1373358960-10900-1-git-send-email-neidhard.kim@lge.com>
	<51DC340F.2060402@atmel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@atmel.com>
Date: Tue, 9 Jul 2013 18:02:23 +0200

> On 09/07/2013 10:36, Jongsung Kim :
>> Signed-off-by: Jongsung Kim <neidhard.kim@lge.com>
> 
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: stable <stable@vger.kernel.org> # 3.10+

Applied and queued up for -stable, thanks.
