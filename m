Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761334Ab3LITvN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 14:51:13 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:44490 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755964Ab3LITvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 14:51:12 -0500
Date: Mon, 9 Dec 2013 11:51:07 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Zhouyi Zhou <zhouzhouyi@gmail.com>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Subject: Re: [PATCH] JFFS2: NULL return of kmem_cache_zalloc should be
 handled.
Message-ID: <20131209195107.GS27149@ld-irv-0074.broadcom.com>
References: <1385980625-26545-1-git-send-email-yizhouzhou@ict.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385980625-26545-1-git-send-email-yizhouzhou@ict.ac.cn>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 06:37:05PM +0800, Zhouyi Zhou wrote:
> NULL return of kmem_cache_zalloc should be handled in jffs2_alloc_xattr_datum
> and jff2_alloc_xattr_ref.
> 
> Signed-off-by: Zhouyi Zhou <yizhouzhou@ict.ac.cn>

Pushed to l2-mtd.git. Thanks!

Brian
