Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab3C0T1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 15:27:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:58888 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab3C0T1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 15:27:51 -0400
Message-ID: <51533A2E.2000501@infradead.org>
Date: Wed, 27 Mar 2013 11:27:58 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Kent Overstreet <koverstreet@google.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [PATCH -next 1/3] bcache: Add missing #include <linux/prefetch.h>
References: <1364406990-20541-1-git-send-email-geert@linux-m68k.org> <20130327182150.GB25906@google.com>
In-Reply-To: <20130327182150.GB25906@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/13 11:21, Kent Overstreet wrote:
> On Wed, Mar 27, 2013 at 06:56:28PM +0100, Geert Uytterhoeven wrote:
>> m68k/allmodconfig:
>>
>> drivers/md/bcache/bset.c: In function ‘bset_search_tree’:
>> drivers/md/bcache/bset.c:727: error: implicit declaration of function ‘prefetch’
>>
>> drivers/md/bcache/btree.c: In function ‘bch_btree_node_get’:
>> drivers/md/bcache/btree.c:933: error: implicit declaration of function ‘prefetch’
> 
> Thanks, applied! The other two I already have a patch queued up for.


On i386 and x86_64, I also see this build problem:

drivers/md/bcache/bset.c:885:4: error: implicit declaration of function '__WARN' [-Werror=implicit-function-declaration]


Do you also have a patch for it?


thanks,
-- 
~Randy
