Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093AbaDVNi4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:38:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756070AbaDVNir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:38:47 -0400
Date: Tue, 22 Apr 2014 09:38:35 -0400
From: Dave Jones <davej@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] vfs: rw_copy_check_uvector() - free iov on error
Message-ID: <20140422133835.GA32718@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux-Fsdevel <linux-fsdevel@vger.kernel.org>
References: <20140415145749.GF10187@tucsk.piliscsaba.szeredi.hu>
 <20140416180422.GA20907@redhat.com>
 <20140421155020.GB13709@redhat.com>
 <CAJfpegs9cgVgxbYZSM=SxyJqj=N1QA5npp7ic6i80CMec+3sZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegs9cgVgxbYZSM=SxyJqj=N1QA5npp7ic6i80CMec+3sZw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 10:42:52AM +0200, Miklos Szeredi wrote:
 
 > >  > Your patch looks a lot more complete than the quick hack I did a few
 > >  > days ago when coverity first started nagging about this, but in testing
 > >  > I've found that something really ugly starts showing up when you patch this
 > >  >
 > >  > The symptoms vary, but always are some kind of slab corruption.
 > >  > Here's the last example:
 > >  >
 > >  > The crash happens very quickly (within a few seconds of running trinity) for me.
 > >
 > > Al, Miklos ?
 > 
 > I probably am blind, but I can't see how that will cause slab corruption.
 > 
 > Have you verified that it's just that single patch and no other change?

yeah, runs a lot longer (before eventually hitting other issues) without
the patch.

	Dave

