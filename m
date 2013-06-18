Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819Ab3FRCHd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 22:07:33 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:50647 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab3FRCHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 22:07:31 -0400
Date: Tue, 18 Jun 2013 10:25:48 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
To: Dave Hansen <dave.hansen@intel.com>, "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jan kara <jack@suse.cz>
Subject: Re: ext4 extent status tree LRU locking
Message-ID: <20130618022548.GA24671@gmail.com>
Mail-Followup-To: Dave Hansen <dave.hansen@intel.com>,
	Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, Jan kara <jack@suse.cz>
References: <51B7B128.60909@intel.com>
 <20130614140940.GA20401@gmail.com>
 <20130614140215.GA1017@thunk.org>
 <20130614170028.GA21544@gmail.com>
 <20130614180054.GB1017@thunk.org>
 <20130617101033.GA17828@gmail.com>
 <51BF7BAA.5030803@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51BF7BAA.5030803@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 02:12:10PM -0700, Dave Hansen wrote:
> On 06/17/2013 03:10 AM, Zheng Liu wrote:
> > Dave, that would be great if you could do your testing again to confirm
> > this patch is useful.
> 
> I was able to apply this to Ted's
> 
> 	https://git.kernel.org/cgit/linux/kernel/git/tytso/ext4.git/
> 
> "ext4/dev" tree with a bit of fuzz.  What did you generate this against,
> btw?

Ah, sorry, I forgot to mention that this patch bases against ext4/master
branch.  Now ext4/dev branch has some regression when I run xfstests.
So I don't base against this branch to generate my patch.

Ted, I notice that now in ext4 tree we have 'dev', 'dev-with-revert',
and 'dev2' branches.  Which one is the best to generate a new patch for
the next merge window?

> 
> It does seem to be functioning OK for me, and passes the other tests
> that saw so much spinlock contention previously.  You can add my
> Tested-by if you like.

Thanks for your testing.

Regards,
                                                - Zheng
