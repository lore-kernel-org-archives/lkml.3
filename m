Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab3CIFjQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 00:39:16 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:38883 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab3CIFjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 00:39:14 -0500
Date: Sat, 9 Mar 2013 08:39:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christopher Li <sparse@chrisli.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux-Sparse <linux-sparse@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Suggestion for fixing the variable length array used in the
 kernel.
Message-ID: <20130309053859.GY9138@mwanda>
References: <CANeU7Qn-5b5U_64QzFt-beP-PyAJgzz=z1100F0v5WbWqZwZOQ@mail.gmail.com>
 <20130308162922.88ad40997d01099949008452@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130308162922.88ad40997d01099949008452@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 04:29:22PM -0800, Andrew Morton wrote:
> On Wed, 6 Mar 2013 20:46:35 -0800 Christopher Li <sparse@chrisli.org> wrote:
> 
> > Hi,
> > 
> > I am looking at the current sparse warning on the kernel source.
> > One category of those warning are produce by the variable length array.
> > We all know that the kernel stack has a limit so we don't want to allocate
> > too much stack to the variable size array.
> > 
> > Is there a recommended way to fix those warnings? Is it worth while to
> > fix it at all? I am looking forward to some kind of guideline how to handle
> > this.
> 
> Roughly how many instances of this are there kernel-wide?
> 

Around 150 on x86 allmodconfig.  They are pretty well audited.

regards,
dan carpenter

