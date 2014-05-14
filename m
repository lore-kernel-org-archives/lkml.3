Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbaENW34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 18:29:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36741 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbaENW3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 18:29:55 -0400
Date: Thu, 15 May 2014 00:29:52 +0200
From: Jan Kara <jack@suse.cz>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        reiserfs-devel@vger.kernel.org, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH V2] fs/reiserfs/stree.c: remove obsolete __constant
Message-ID: <20140514222952.GA21766@quack.suse.cz>
References: <20140503223324.4357f591dc8994b74f456440@skynet.be>
 <20140514220143.GA20841@quack.suse.cz>
 <CAFLxGvzp_8Qgg0wN2v0SncAB+eDEn4s-p86ZW9+DzosBKb53yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFLxGvzp_8Qgg0wN2v0SncAB+eDEn4s-p86ZW9+DzosBKb53yw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 15-05-14 00:08:34, Richard Weinberger wrote:
> On Thu, May 15, 2014 at 12:01 AM, Jan Kara <jack@suse.cz> wrote:
> > On Sat 03-05-14 22:33:24, Fabian Frederick wrote:
> >> __constant_cpu_to_le32 converted to cpu_to_le32
> >>
> >> Cc: reiserfs-devel@vger.kernel.org
> >> Cc: Andrew Morton <akpm@linux-foundation.org>
> >> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> >   Just for my education, where have you learned that __constant_...
> > functions are obsolete?
> 
> IIRC checkpatch.pl barks if you use __constant_... outside of include/uapi/
  OK. I've merged the patch into my tree.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
