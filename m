Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993AbaHYIZz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 04:25:55 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:40692 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754965AbaHYIZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 04:25:52 -0400
MIME-Version: 1.0
In-Reply-To: <20140825043755.GE32620@bbox>
References: <1408668134-21696-1-git-send-email-minchan@kernel.org>
 <1408668134-21696-4-git-send-email-minchan@kernel.org> <CAFdhcLQXHoCT2tee8f1hb-XOsh4G5SQUGfhXtobNYjDq6MS9Ug@mail.gmail.com>
 <20140824235607.GJ17372@bbox> <CAFdhcLRvwifCVyoW5F9gdOGwcNd0PM679HckJY6+UDYV82n+bg@mail.gmail.com>
 <20140825043755.GE32620@bbox>
From: Dongsheng Song <dongsheng.song@gmail.com>
Date: Mon, 25 Aug 2014 16:25:31 +0800
Message-ID: <CAE8XmWojKVaaY2GzRnpOVzc9cMeX2fb3nRC0JyBgrhPu1QaBEw@mail.gmail.com>
Subject: Re: [PATCH v4 3/4] zram: zram memory size limitation
To: Minchan Kim <minchan@kernel.org>
Cc: David Horner <ds2horner@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Jerome Marchand <jmarchan@redhat.com>, juno.choi@lge.com,
        seungho1.park@lge.com, Luigi Semenzato <semenzato@google.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjennings@variantweb.net>,
        Dan Streetman <ddstreet@ieee.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +What:          /sys/block/zram<id>/mem_limit
> +Date:          August 2014
> +Contact:       Minchan Kim <minchan@kernel.org>
> +Description:
> +               The mem_limit file is read/write and specifies the amount
 > +               of memory to be able to consume memory to store store
> +               compressed data. The limit could be changed in run time
> +               and "0" means disable the limit. No limit is the initial state.

extra word 'store' ?
The mem_limit file is read/write and specifies the amount of memory to
be able to consume memory to store store compressed data.

maybe this better ?
The mem_limit file is read/write and specifies the amount of memory to
store compressed data.

--
Dongsheng
