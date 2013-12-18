Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab3LRH52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 02:57:28 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:64506 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab3LRH51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 02:57:27 -0500
Date: Tue, 17 Dec 2013 23:57:22 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        David Woodhouse <dwmw2@infradead.org>, josh@joshtriplett.org
Subject: Re: [PATCH 1/2] drivers: mtd: Mark functions as static and remove
 unused function in lpddr_cmds.c
Message-ID: <20131218075722.GD5551@norris-Latitude-E6410>
References: <d0512c2bc35b27af33ad79d74d93ecc0f2b4e92c.1386912859.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d0512c2bc35b27af33ad79d74d93ecc0f2b4e92c.1386912859.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 12:44:07PM +0530, Rashika Kheria wrote:
> This patch marks the functions do_write_buffer() and do_erase_oneblock()
> as static because because they are not used outside this file. It also
> removes the unused function word_program() in lpddr/lpddr_cmds.c.
> 
> Thus, it also removes the following warnings in lpddr/lpddr_cmds.c:
> drivers/mtd/lpddr/lpddr_cmds.c:391:5: warning: no previous prototype for ‘do_write_buffer’ [-Wmissing-prototypes]
> drivers/mtd/lpddr/lpddr_cmds.c:472:5: warning: no previous prototype for ‘do_erase_oneblock’ [-Wmissing-prototypes]
> drivers/mtd/lpddr/lpddr_cmds.c:751:5: warning: no previous prototype for ‘word_program’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Edited the $subjects and pushed both to l2-mtd.git. Thanks!

Brian
