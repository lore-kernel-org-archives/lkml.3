Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbaIHREk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 13:04:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:40260 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095AbaIHREj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 13:04:39 -0400
Message-ID: <540DE1A3.7080302@infradead.org>
Date: Mon, 08 Sep 2014 10:04:35 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>, linux-kernel@vger.kernel.org,
        trivial@kernel.org
CC: akpm@linux-foundation.org
Subject: Re: [PATCH][trivial] Documentation: Docbook: Fix typo in DocBook/kernel-api.xml
References: <1410193643-29232-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1410193643-29232-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/14 09:27, Masanari Iida wrote:
> This patch fix spelling typo found in DocBook/kernel-api.xml.
> It is because the file is generated from the source comments,
> I have to fix the comments in source codes.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  block/blk-core.c      | 8 ++++----
>  block/genhd.c         | 2 +-
>  include/linux/clk.h   | 2 +-
>  include/linux/kfifo.h | 2 +-
>  ipc/util.c            | 6 +++---
>  kernel/auditsc.c      | 2 +-
>  lib/bitmap.c          | 4 ++--
>  lib/idr.c             | 2 +-
>  lib/vsprintf.c        | 2 +-
>  mm/filemap.c          | 2 +-
>  security/inode.c      | 2 +-
>  11 files changed, 17 insertions(+), 17 deletions(-)


-- 
~Randy
