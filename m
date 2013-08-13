Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502Ab3HMHYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 03:24:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33363 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755862Ab3HMHYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 03:24:51 -0400
Date: Tue, 13 Aug 2013 00:26:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Shyam Kaushik <shyam@zadarastorage.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: BUG REPORT - IDR wraps around at 30-bits - works very bad with
 NFSD/SCTP
Message-ID: <20130813072616.GA14019@kroah.com>
References: <9a92eee58fefc1b8e3b4771ecf210d29@mail.gmail.com>
 <20130813071944.GA11270@kroah.com>
 <199217e8a2fc33f6aa0ecf764a0104cb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <199217e8a2fc33f6aa0ecf764a0104cb@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 12:51:14PM +0530, Shyam Kaushik wrote:
> Hi Greg,
> 
> Unfortunately we don’t have a 3.9/3.10 environment here. So if IDR
> developers can try the example code, it should show if the bug is still
> present in there. Thanks.

There shouldn't be anything in 3.10 preventing you from building and
testing it out, is there?  Or do you have something that restricts you
to specific kernel versions?

thanks,

greg k-h
