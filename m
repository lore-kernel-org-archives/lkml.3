Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240Ab3K0Svv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 13:51:51 -0500
Received: from merlin.infradead.org ([205.233.59.134]:58798 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338Ab3K0Svu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 13:51:50 -0500
Message-ID: <1385578303.5151.110.camel@smoke>
Subject: Re: [PATCH 04/25] block: Abstract out bvec iterator
From: Geoff Levand <geoff@infradead.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jens Axboe <axboe@kernel.dk>, Jim Paris <jim@jtan.com>
Date: Wed, 27 Nov 2013 10:51:43 -0800
In-Reply-To: <1385513128-5035-4-git-send-email-kmo@daterainc.com>
References: <20131127004422.GB21305@kmo>
	 <1385513128-5035-1-git-send-email-kmo@daterainc.com>
	 <1385513128-5035-4-git-send-email-kmo@daterainc.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-26 at 16:45 -0800, Kent Overstreet wrote:
> Immutable biovecs are going to require an explicit iterator. To
> implement immutable bvecs, a later patch is going to add a bi_bvec_done
> member to this struct; for now, this patch effectively just renames
> things.

>  drivers/block/ps3disk.c                     |  2 +-
>  drivers/block/ps3vram.c                     |  2 +-

The PS3 parts look OK.  Please try to test a powerpc build  with
ps3_defconfig.

Acked-by: Geoff Levand <geoff@infradead.org>

