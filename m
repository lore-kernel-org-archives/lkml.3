Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab3LXPUR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 10:20:17 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:59848 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308Ab3LXPUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 10:20:15 -0500
Date: Tue, 24 Dec 2013 23:19:04 +0800
From: Wang YanQing <udknight@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] softirq: Use const char * const for softirq_to_name,
 whitespace neatening
Message-ID: <20131224151904.GA3398@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	Joe Perches <joe@perches.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <cover.1384656563.git.joe@perches.com>
 <ec5c256bd326246f4b12dde34455c1df9b71004d.1384656563.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec5c256bd326246f4b12dde34455c1df9b71004d.1384656563.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 17, 2013 at 01:55:12AM -0800, Joe Perches wrote:
> Reduce data size a little.
> Reduce checkpatch noise.
> 
> $ size kernel/softirq.o*
>    text	   data	    bss	    dec	    hex	filename
>   11554	   6013	   4008	  21575	   5447	kernel/softirq.o.new
>   11474	   6093	   4008	  21575	   5447	kernel/softirq.o.old

Hi, could you tell me why this patch could reduce data size?

Thanks.
