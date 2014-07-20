Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbaGTUTe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 16:19:34 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:52156 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354AbaGTUTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 16:19:32 -0400
Date: Sun, 20 Jul 2014 13:19:24 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Bivolaru Catalin <bivolaru.catalin@gmail.com>,
        kernel-janitors@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, paul.gortmaker@windriver.com
Subject: Re: [PATCH] staging: input: sunkbd.c: Fix coding style
Message-ID: <20140720201924.GA18347@core.coreip.homeip.net>
References: <20140720120103.GA5294@kalio-PC>
 <1405871574.5135.24.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405871574.5135.24.camel@joe-AO725>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2014 at 08:52:54AM -0700, Joe Perches wrote:
> On Sun, 2014-07-20 at 15:01 +0300, Bivolaru Catalin wrote:
> > Fix coding style with regard to missing spaces after , and the column limit
> > that was violated after the first change.
> 
> Some checkpatch errors should be ignored.
> 
> These are some of them.
> 
> This change doesn't make it easier to read
> or to find any array entry.
> 
> It's currently in groups of 16 (0x10).
> 
> This change would make it very difficult
> to find any particular entry.
> 
> It might make some sense to change the last
> line to add a trailing "  0,  0" entry as
> the compiler does to make it a bit clearer
> the table has 128 entries.

I'd rather not change a thing in this table - it has been working as is
for many years.

Thanks.

-- 
Dmitry
