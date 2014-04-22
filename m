Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932959AbaDVPCq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:02:46 -0400
Received: from 216-12-86-13.cv.mvl.ntelos.net ([216.12.86.13]:41981 "EHLO
	brightrain.aerifal.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756692AbaDVPCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:02:40 -0400
Date: Tue, 22 Apr 2014 11:00:56 -0400
From: Rich Felker <dalias@libc.org>
To: Boaz Harrosh <openosd@gmail.com>
Cc: Jeff Layton <jlayton@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
        Ganesha NFS List <nfs-ganesha-devel@lists.sourceforge.net>,
        libc-alpha <libc-alpha@sourceware.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Carlos O'Donell" <carlos@redhat.com>,
        Stefan Metzmacher <metze@samba.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Frank Filz <ffilzlnx@mindspring.com>, "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] locks: rename file-private locks to "open file
 description locks"
Message-ID: <20140422150056.GL26358@brightrain.aerifal.cx>
References: <1398169383-10743-1-git-send-email-jlayton@redhat.com>
 <5356808B.3040303@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5356808B.3040303@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 05:45:31PM +0300, Boaz Harrosh wrote:
> On 04/22/2014 03:23 PM, Jeff Layton wrote:
> <>
> > 
> > We're going to have to live with these for a long time, so it's
> > important that we be happy with the names before we're stuck with them.
> > The consensus on the lists so far is that they should be rechristened as
> > "open file description locks".
> > 
> 
> I completely agree with the rename. (Though could you please post
> the rest of the rename patches for review)
> 
> Just a very small nit. My native language is not English but I would
> rather you use "file-descriptor" (with an '-' as well) and not
> use "description" in the English name of the lock. This is
> because stated like that, "description" might refer to the
> locks and not to the file in the sentence. file-descriptor is
> more clear I think. (For me it was confusing at first before I realized
> what you meant)

I think you missed the whole point. "File descriptor" and "open file
description" have DIFFERENT meanings. Replacing one with the other
gives the wrong meaning.

Rich
