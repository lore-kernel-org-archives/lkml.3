Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876AbaKZSKf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 13:10:35 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:39702 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbaKZSKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 13:10:33 -0500
Date: Wed, 26 Nov 2014 10:10:30 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: zhangxingcai <zhangxingcai@huawei.com>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, fengfuqiu@huawei.com,
        tanhaijun@huawei.com
Subject: Re: [PATCH 3/3] [PATCH] mtd: fix concurrent access to mtd->usecount
Message-ID: <20141126181030.GC21347@ld-irv-0074>
References: <1417008990-24413-1-git-send-email-zhangxingcai@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417008990-24413-1-git-send-email-zhangxingcai@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 09:36:30PM +0800, zhangxingcai wrote:
[...]

What series is this patch 3/3 of? It looks like it stands alone, and I
wasn't CC'd on anything else related to it.

Brian
