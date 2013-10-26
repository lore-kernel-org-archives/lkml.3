Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963Ab3JZKOv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 06:14:51 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:34613 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab3JZKOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 06:14:49 -0400
Message-ID: <1382782485.5901.22.camel@karhu.quadriga.com>
Subject: Re: [PATCH] UBIFS: fix error return code in ubifs_remount_rw() and
 ubifs_fill_super()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Brian Norris <computersforpeace@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>, yongjun_wei@trendmicro.com.cn,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Wei Yongjun <weiyj.lk@gmail.com>
Date: Sat, 26 Oct 2013 11:14:45 +0100
In-Reply-To: <CAN8TOE96Ax_gyeG5fXHejHE6gCmxNchioy1BrE8a6B83kK7A8g@mail.gmail.com>
References: <CAPgLHd_=Y=YwCWSFjcacJ14yKUidmmJTHnKKibU6haoBUeNacA@mail.gmail.com>
	 <CAN8TOE96Ax_gyeG5fXHejHE6gCmxNchioy1BrE8a6B83kK7A8g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2013-10-02 at 12:59 -0700, Brian Norris wrote:
> Bump, Artem? I'm cleaning out my old email, and this patch looks
> obviously correct.

Picked to linux-ubifs.git, thanks!

-- 
Best Regards,
Artem Bityutskiy

