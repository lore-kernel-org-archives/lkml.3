Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbbAVDS3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 22:18:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41515 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbbAVDSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 22:18:24 -0500
Date: Thu, 22 Jan 2015 11:18:19 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Steven Rostedt <rostedt@goodmis.org>, tj@kernel.org
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 0/5] tracing: Add new file system tracefs
Message-ID: <20150122031819.GA16561@kroah.com>
References: <20150121171953.823177070@goodmis.org>
 <20150121230007.GA10389@kroah.com>
 <20150121204725.71933044@grimm.local.home>
 <20150121220701.22231849@grimm.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150121220701.22231849@grimm.local.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 10:07:01PM -0500, Steven Rostedt wrote:
> On Wed, 21 Jan 2015 20:47:25 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > Well, if I switch to using kernfs, I expect we should ignore this
> > version as well, as I would think it would make this series obsolete.
> 
> Is there any documentation on kernfs? I can't find anything that makes
> it any easier than what I already have.

Tejun would know best, he wrote it :)

What specifically are you looking for?  I think there's at least two
filesystems using it already, are they not good enough examples?

thanks,

greg k-h
