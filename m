Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014Ab3HMOv3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 10:51:29 -0400
Received: from mail-gh0-f181.google.com ([209.85.160.181]:40114 "EHLO
	mail-gh0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab3HMOv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 10:51:28 -0400
Date: Tue, 13 Aug 2013 10:51:24 -0400
From: Tejun Heo <tj@kernel.org>
To: Shyam Kaushik <shyam@zadarastorage.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: BUG REPORT - IDR wraps around at 30-bits - works very bad with
 NFSD/SCTP
Message-ID: <20130813145124.GB26596@mtj.dyndns.org>
References: <9a92eee58fefc1b8e3b4771ecf210d29@mail.gmail.com>
 <20130813071944.GA11270@kroah.com>
 <199217e8a2fc33f6aa0ecf764a0104cb@mail.gmail.com>
 <20130813072616.GA14019@kroah.com>
 <446f41f4a3ea0c758b05c0348d2b6f5d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <446f41f4a3ea0c758b05c0348d2b6f5d@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Aug 13, 2013 at 01:21:12PM +0530, Shyam Kaushik wrote:
> Any chances of backporting some parts of fix to <3.9 kernels?

For kernels which are too old for -stable, backporting is up to the
distros which hopefully are still maintaining the kernel (you really
don't want to run an unmaintained distro anyway).  The IDR changes
shouldn't be difficult to pick up and the best way to make that happen
would be filing a bug with the distro.

Thanks.

-- 
tejun
