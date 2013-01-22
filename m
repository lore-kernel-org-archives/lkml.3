Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324Ab3AVX6N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 18:58:13 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:57262 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756187Ab3AVX6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 18:58:11 -0500
MIME-Version: 1.0
In-Reply-To: <1358898745-4873-1-git-send-email-minchan@kernel.org>
References: <1358898745-4873-1-git-send-email-minchan@kernel.org>
Date: Tue, 22 Jan 2013 15:58:10 -0800
Message-ID: <CAPkvG_f2mDr2p=ypqcikeNMRoE3tK1-kDjLWyz6bb9yQUpGgZQ@mail.gmail.com>
Subject: Re: [PATCH v5 1/4] zram: Fix deadlock bug in partial write
From: Nitin Gupta <ngupta@vflare.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, jmarchan@redhat.com,
        stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 3:52 PM, Minchan Kim <minchan@kernel.org> wrote:
> Now zram allocates new page with GFP_KERNEL in zram I/O path
> if IO is partial. Unfortunately, It may cuase deadlock with
> reclaim path so this patch solves the problem.
>
> Cc: Jerome Marchand <jmarchan@redhat.com>
> Cc: stable@vger.kernel.org
> Acked-by: Nitin Gupta <ngupta@vflare.org>
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> ---
>  drivers/staging/zram/zram_drv.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>

Changelog for v4 vs v5?

Thanks,
Nitin
