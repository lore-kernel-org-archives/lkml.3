Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317AbaHZGkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 02:40:53 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:49045 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757182AbaHZGkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 02:40:51 -0400
Date: Tue, 26 Aug 2014 10:40:48 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: linux-next: build failure after merge of the akpm-current tree
Message-ID: <20140826064048.GA3063@moon>
References: <20140826163502.33a837fc@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140826163502.33a837fc@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 04:35:02PM +1000, Stephen Rothwell wrote:
> Hi Andrew,
> 
> After merging the akpm-current tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> ./usr/include/linux/prctl.h:132: found __[us]{8,16,32,64} type without #include <linux/types.h>
> In file included from /usr/include/x86_64-linux-gnu/sys/prctl.h:23:0,
>                  from Documentation/prctl/disable-tsc-test.c:14:
> ./usr/include/linux/prctl.h:132:2: error: unknown type name '__u64'
...

Thanks for report, Stephen! I'll fix.
