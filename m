Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216Ab3KNBGi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 20:06:38 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:58954 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab3KNBGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 20:06:31 -0500
Date: Wed, 13 Nov 2013 17:06:27 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH 02/12] mtd: Remove superfluous name casts
Message-ID: <20131114010627.GK9468@ld-irv-0074.broadcom.com>
References: <1384283245-9419-1-git-send-email-geert@linux-m68k.org>
 <1384283245-9419-3-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384283245-9419-3-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 08:07:15PM +0100, Geert Uytterhoeven wrote:
> map_info.name is "const char *"
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: linux-mtd@lists.infradead.org

Pushed to l2-mtd.git/next. Thanks!

Brian
