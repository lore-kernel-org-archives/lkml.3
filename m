Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588AbaLZTRU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 14:17:20 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:53744 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbaLZTRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 14:17:17 -0500
Message-ID: <549DB43B.7050902@infradead.org>
Date: Fri, 26 Dec 2014 11:17:15 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Changman Lee <cm224.lee@samsung.com>
Subject: Re: linux-next: Tree for Dec 26 (f2fs)
References: <20141226193009.60d3f62e@canb.auug.org.au>
In-Reply-To: <20141226193009.60d3f62e@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26/14 00:30, Stephen Rothwell wrote:
> Hi all,
> 
> There will only be intermittent releases of linux-next between now and
> Jan 5.
> 
> Changes since 20141221:
> 

on x86_64:
when CONFIG_F2FS_STAT_FS is not enabled:

../fs/f2fs/segment.c: In function 'rewrite_data_page':
../fs/f2fs/segment.c:1233:2: error: implicit declaration of function 'stat_inc_inplace_blocks' [-Werror=implicit-function-declaration]



-- 
~Randy
