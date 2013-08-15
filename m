Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758297Ab3HOASs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 20:18:48 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:36790 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab3HOASq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 20:18:46 -0400
MIME-Version: 1.0
In-Reply-To: <20130814161753.GB2706@gmail.com>
References: <1376459736-7384-1-git-send-email-minchan@kernel.org>
	<CAA25o9Q1KVHEzdeXJFe9A8K9MULysq_ShWrUBZM4-h=5vmaQ8w@mail.gmail.com>
	<20130814161753.GB2706@gmail.com>
Date: Thu, 15 Aug 2013 08:18:46 +0800
Message-ID: <CAA_GA1da3jkOO9Y3+L6_DMmiH8wsbJJ-xcUxUK_Gh2SYPPbjoA@mail.gmail.com>
Subject: Re: [PATCH v6 0/5] zram/zsmalloc promotion
From: Bob Liu <lliubbo@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Luigi Semenzato <semenzato@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Linux-Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 12:17 AM, Minchan Kim <minchan@kernel.org> wrote:
> Hi Luigi,
>
> On Wed, Aug 14, 2013 at 08:53:31AM -0700, Luigi Semenzato wrote:
>> During earlier discussions of zswap there was a plan to make it work
>> with zsmalloc as an option instead of zbud. Does zbud work for
>
> AFAIR, it was not an optoin but zsmalloc was must but there were
> several objections because zswap's notable feature is to dump
> compressed object to real swap storage. For that, zswap needs to
> store bounded objects in a zpage so that dumping could be bounded, too.
> Otherwise, it could encounter OOM easily.
>

AFAIR, the next step of zswap should be have a modular allocation layer so that
users can choose zsmalloc or zbud to use.

Seth?

-- 
Regards,
--Bob
