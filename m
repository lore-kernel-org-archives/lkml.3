Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab3KNBKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 20:10:20 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:51567 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab3KNBKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 20:10:14 -0500
Date: Wed, 13 Nov 2013 17:10:09 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd: Make mtd_partition.name const
Message-ID: <20131114011009.GN9468@ld-irv-0074.broadcom.com>
References: <1384283486-10348-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384283486-10348-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 08:11:26PM +0100, Geert Uytterhoeven wrote:
> This allows to drop a few casts.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Pushed to l2-mtd.git/next. Thanks!

Brian
