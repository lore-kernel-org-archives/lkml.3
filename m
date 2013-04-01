Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602Ab3DAGOq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 02:14:46 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:59474 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757222Ab3DAGOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 02:14:45 -0400
X-Greylist: delayed 111420 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Apr 2013 02:14:45 EDT
Date: Sun, 31 Mar 2013 23:10:47 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'David Woodhouse'" <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power: abx500_chargalg: use module_platform_driver()
 macro
Message-ID: <20130401061044.GD25376@lizard>
References: <007001ce1e21$df084be0$9d18e3a0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <007001ce1e21$df084be0$9d18e3a0$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 03:30:06PM +0900, Jingoo Han wrote:
> This patch uses module_platform_driver() macro which makes
> the code smaller and simpler.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---

Similar change was in a "big ab8500 sync"..

commit 1ee26af028a46cf911f844c062b3c810bac34366
Author: srinidhi kasagar <srinidhi.kasagar@stericsson.com>
Date:   Thu Oct 11 14:38:28 2012 +0530

    abx500-chargalg: Use module_platform_driver() rather

Thanks,

Anton
