Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbbAVMdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 07:33:20 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:64561 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbbAVMdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 07:33:18 -0500
Date: Thu, 22 Jan 2015 07:33:14 -0500
From: Tejun Heo <tj@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 0/5] tracing: Add new file system tracefs
Message-ID: <20150122123314.GC25645@htj.dyndns.org>
References: <20150121171953.823177070@goodmis.org>
 <20150121230007.GA10389@kroah.com>
 <20150121204725.71933044@grimm.local.home>
 <20150121220701.22231849@grimm.local.home>
 <20150122031819.GA16561@kroah.com>
 <20150121225109.6b27b555@grimm.local.home>
 <20150122123212.GB25645@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150122123212.GB25645@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 07:32:12AM -0500, Tejun Heo wrote:
> > Yes, I can study the code, but I was hoping that there was some
> > kernfs.txt that described how to create a new fs with it. It just saves
> > time if there was a document than having to read the code and perhaps
> > use it in a way it wasn't supposed to be used.
> 
> Yeah yeah, I hear you.  I'll write one up.

But all the public APIs are well documented with docbook comments, so
for the time being, I'd recommend those as the starting point.

Thanks.

-- 
tejun
