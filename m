Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926AbaHHPeG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 11:34:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56184 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769AbaHHPeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 11:34:04 -0400
Date: Fri, 8 Aug 2014 17:34:02 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] printk: Don't bother using LOG_CPU_MAX_BUF_SHIFT on
	!SMP
Message-ID: <20140808153402.GE21930@wotan.suse.de>
References: <1407511244-5332-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407511244-5332-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2014 at 05:20:44PM +0200, Geert Uytterhoeven wrote:
> When configuring a uniprocessor kernel, don't bother the user with an
> irrelevant LOG_CPU_MAX_BUF_SHIFT question, and don't build the unused
> code.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: Luis R. Rodriguez <mcgrof@suse.com>

  Luis
