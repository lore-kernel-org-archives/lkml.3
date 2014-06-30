Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbaF3Q0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:26:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39447 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbaF3Q0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:26:24 -0400
Date: Mon, 30 Jun 2014 09:26:09 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] debugfs: Fix corrupted loop in
 debugfs_remove_recursive
Message-ID: <20140630162609.GC24179@kroah.com>
References: <20140609140607.3e3aae39@gandalf.local.home>
 <20140610093357.7ef3792b@gandalf.local.home>
 <20140610202302.GB20499@kroah.com>
 <20140630115331.5135b511@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140630115331.5135b511@gandalf.local.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 11:53:31AM -0400, Steven Rostedt wrote:
> On Tue, 10 Jun 2014 13:23:02 -0700
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> 
> > Anyway, thanks for the patch, I'll queue it up after 3.16-rc1 is out.
> 
> Did this patch get dropped?

No, it's still in my "to-apply" queue, just been on the road for a
while.  I'll get to it after the 5th...

greg k-h
