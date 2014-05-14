Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbaENUKD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 16:10:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37257 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbaENUKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 16:10:00 -0400
Date: Wed, 14 May 2014 16:09:52 -0400 (EDT)
Message-Id: <20140514.160952.163572638108264834.davem@redhat.com>
To: reksio@newterm.pl
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver/net/ethernet/ec_bhf.c: fix sparse warnings
From: David Miller <davem@redhat.com>
In-Reply-To: <20140514060431.GA5641@newterm.pl>
References: <20140514060431.GA5641@newterm.pl>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Darek Marcinkiewicz <reksio@newterm.pl>
Date: Wed, 14 May 2014 08:04:32 +0200

> Sparse was reporting quite a few warnings for the driver.
> Those get fixed by this patch.
> 
> Signed-off-by: Dariusz Marcinkiewicz <reksio@newterm.pl>

Applied to net-next, thank you.
