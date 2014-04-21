Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbaDUQlh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 12:41:37 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:36419 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149AbaDUQlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 12:41:32 -0400
Message-ID: <53554A47.50100@kernel.dk>
Date: Mon, 21 Apr 2014 10:41:43 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>, LKML <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] fs: fix new kernel-doc warnings in fs/bio.c
References: <53545243.9000005@infradead.org>
In-Reply-To: <53545243.9000005@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2014 05:03 PM, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix new kernel-doc warnings in fs/bio.c:
> 
> Warning(fs/bio.c:316): No description found for parameter 'bio'
> Warning(fs/bio.c:316): No description found for parameter 'parent'

Thanks Randy, applied.

-- 
Jens Axboe

