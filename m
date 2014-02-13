Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918AbaBMTcQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:32:16 -0500
Received: from fieldses.org ([174.143.236.118]:43450 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbaBMTcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:32:15 -0500
Date: Thu, 13 Feb 2014 14:32:05 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, dhowells@redhat.com,
        zab@redhat.com, jack@suse.cz, luto@amacapital.net, mszeredi@suse.cz
Subject: Re: [PATCH 00/13] cross rename v4
Message-ID: <20140213193205.GC20694@fieldses.org>
References: <1391791751-2533-1-git-send-email-miklos@szeredi.hu>
 <20140207224630.GD8801@fieldses.org>
 <20140211155744.GC8204@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140211155744.GC8204@tucsk.piliscsaba.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 04:57:44PM +0100, Miklos Szeredi wrote:
> On Fri, Feb 07, 2014 at 05:46:30PM -0500, J. Bruce Fields wrote:
> 
> > > Bruce, could you please review the locking and delegation thing in patch #8
> > > "vfs: add cross-rename"?
> > 
> > Yep, done.  I'll also try running this through my nfs tests, for what
> > it's worth.  (Not today as there's some unrelated regression to sort
> > out first.)
> > 
> > Feel free to add a
> > 
> > 	Reviewed-by: J. Bruce Fields <bfields@redhat.com>
> > 
> > for any but the ext4 patches, which I skipped.
> 
> Thanks for the review!
> 
> I've changed the authorship of the lock_two_nondirectories() patch to you.  Can
> I also add your sign-off?

Sure; thanks!

--b.
