Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab3FIOVa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 10:21:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40073 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab3FIOV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 10:21:29 -0400
Message-ID: <1370787681.3610.4.camel@clam>
Subject: Re: [PATCH 06/26] block: Convert bio_for_each_segment() to bvec_iter
From: Geoff Levand <geoff@infradead.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Date: Sun, 09 Jun 2013 07:21:21 -0700
In-Reply-To: <1370744348-15407-7-git-send-email-koverstreet@google.com>
References: <1370744348-15407-1-git-send-email-koverstreet@google.com>
	 <1370744348-15407-7-git-send-email-koverstreet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-06-08 at 19:18 -0700, Kent Overstreet wrote:
More prep work for immutable biovecs - with immutable bvecs drivers
> won't be able to use the biovec directly, they'll need to use helpers
> that take into account bio->bi_iter.bi_bvec_done.
> 
> drivers/block/ps3vram.c                  | 10 ++---

ps3vram part looks OK.

Acked-by: Geoff Levand <geoff@infradead.org>


