Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab3BMSgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:36:08 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:42911 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab3BMSgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:36:06 -0500
Date: Wed, 13 Feb 2013 13:36:03 -0500 (EST)
Message-Id: <20130213.133603.392678696679169085.davem@davemloft.net>
To: nicolas.ferre@atmel.com
Cc: netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, plagnioj@jcrosoft.com,
        mailinglists@erwinrol.com
Subject: Re: [PATCH] net/macb: fix race with RX interrupt while doing NAPI
From: David Miller <davem@davemloft.net>
In-Reply-To: <1360663728-10296-1-git-send-email-nicolas.ferre@atmel.com>
References: <50D2D7BD.3030801@erwinrol.com>
	<1360663728-10296-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@atmel.com>
Date: Tue, 12 Feb 2013 11:08:48 +0100

> When interrupts are disabled, an RX condition can occur but
> it is not reported when enabling interrupts again. We need to check
> RSR and use napi_reschedule() if condition is met.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Applied.
