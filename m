Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbaHDV1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 17:27:18 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:38710 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbaHDV1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 17:27:17 -0400
Date: Mon, 4 Aug 2014 14:27:14 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Masahiro Yamada <yamada.m@jp.panasonic.com>
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Huang Shijie <shijie8@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mtd: denali: avoid using a magic number
Message-ID: <20140804212714.GE3711@ld-irv-0074>
References: <1405044846-21447-1-git-send-email-yamada.m@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405044846-21447-1-git-send-email-yamada.m@jp.panasonic.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 11:14:05AM +0900, Masahiro Yamada wrote:
> MAP10 command with '0x2000' data sets up a read-ahead/write access.
> 
> Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>

Queued to l2-mtd.git/next.

Brian
