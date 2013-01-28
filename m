Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab3A1Dmc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 22:42:32 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:49609 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436Ab3A1Dma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 22:42:30 -0500
MIME-Version: 1.0
In-Reply-To: <1359135978-15119-4-git-send-email-sjenning@linux.vnet.ibm.com>
References: <1359135978-15119-1-git-send-email-sjenning@linux.vnet.ibm.com>
	<1359135978-15119-4-git-send-email-sjenning@linux.vnet.ibm.com>
Date: Mon, 28 Jan 2013 12:42:29 +0900
X-Google-Sender-Auth: iOCMIC_5ITKyhKTubcUtYI2bhNA
Message-ID: <CAEwNFnDHLgcBt81ZWZqrNSn2ctu86N6Y3JbgqoKVNuq85zU1nw@mail.gmail.com>
Subject: Re: [PATCH 3/4] staging: zsmalloc: add page alloc/free callbacks
From: Minchan Kim <minchan@kernel.org>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2013 at 2:46 AM, Seth Jennings
<sjenning@linux.vnet.ibm.com> wrote:
> This patch allows users of zsmalloc to register the
> allocation and free routines used by zsmalloc to obtain
> more pages for the memory pool.  This allows the user
> more control over zsmalloc pool policy and behavior.
>
> If the user does not wish to control this, alloc_page() and
> __free_page() are used by default.
>
> Acked-by: Nitin Gupta <ngupta@vflare.org>
> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
Acked-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
