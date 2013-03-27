Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab3C0SV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 14:21:56 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:65110 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab3C0SVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 14:21:53 -0400
Date: Wed, 27 Mar 2013 11:21:50 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org
Subject: Re: [PATCH -next 1/3] bcache: Add missing #include <linux/prefetch.h>
Message-ID: <20130327182150.GB25906@google.com>
References: <1364406990-20541-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1364406990-20541-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 06:56:28PM +0100, Geert Uytterhoeven wrote:
> m68k/allmodconfig:
> 
> drivers/md/bcache/bset.c: In function ‘bset_search_tree’:
> drivers/md/bcache/bset.c:727: error: implicit declaration of function ‘prefetch’
> 
> drivers/md/bcache/btree.c: In function ‘bch_btree_node_get’:
> drivers/md/bcache/btree.c:933: error: implicit declaration of function ‘prefetch’

Thanks, applied! The other two I already have a patch queued up for.
