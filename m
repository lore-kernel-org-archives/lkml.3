Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759621Ab3CHXeb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 18:34:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756158Ab3CHXea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 18:34:30 -0500
Date: Fri, 8 Mar 2013 18:34:27 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: BUG_ON(nd->inode != parent->d_inode);
Message-ID: <20130308233427.GB32587@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>
References: <CA+55aFxAfWHdSH+45qgids1ByBxzieZnz_ujRXYGY-at1mg5eg@mail.gmail.com>
 <20130308191804.GA9774@redhat.com>
 <20130308192042.GA10305@redhat.com>
 <20130308193652.GA11692@redhat.com>
 <CA+55aFyE12rZ3DZUtTkonPjbcQiZNdAmys7w5zf7_Xry2z=-2A@mail.gmail.com>
 <20130308210432.GA21500@redhat.com>
 <CA+55aFyNAA3u2k_38iqRPN0EqtP=qXu1wu_vnXnAgQmp6NwGJA@mail.gmail.com>
 <20130308230734.GA28317@redhat.com>
 <CA+55aFxKgZyqbn1M0sAL0CoLxmKSzAALYBTPLYVM7OpG_M_B=A@mail.gmail.com>
 <CA+55aFw=v3uBZUfzUePThL_=+qteoTqg20_ZumaDkCvX90AzkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw=v3uBZUfzUePThL_=+qteoTqg20_ZumaDkCvX90AzkQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 03:28:01PM -0800, Linus Torvalds wrote:
 > Oh, btw, I'm assuming you're testing current git like you usually do.
 
yes.

 > If so, just to humor me, can you try plain 3.8 (or 3.8.2 or whatever
 > the current stable kernel is). Because while the oopses may be due to
 > your extensions to trinity, let's make sure. Maybe something bad
 > happened in the merge window, and we're just wasting time trying to
 > figure it out, when it could be just bisected...

Sure, will do.

 > The pipe and symlink BUG_ON() bugs you've found are likely real and
 > old, so keep the patches for those around, but let's just verify that
 > the BUG_ON(nd->inode != parent->d_inode);" is old too.
 > 
 > I suspect it's a real and old bug, and that you'll be able to recreate
 > it with the stable kernels too, but just to make sure..

Hopefully I won't uncover anything new.

	Dave

