Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933218Ab3ICTdO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 15:33:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51523 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932109Ab3ICTdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 15:33:12 -0400
Date: Tue, 3 Sep 2013 12:33:11 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Richard Weinberger <richard@nod.at>
Cc: Jeff Liu <jeff.liu@oracle.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        "ocfs2-users@oss.oracle.com" <ocfs2-users@oss.oracle.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sunil Mushran <sunil.mushran@gmail.com>
Subject: Re: OCFS2: ocfs2_read_blocks:285 ERROR: block 532737 had the JBD
	bit set while I was in lock_buffer!
Message-ID: <20130903193311.GR31381@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <CAFLxGvwLJs0ZrOZN-g=fCDEN4eAOQMjW_Nojm9fm5Rq0GKk9AQ@mail.gmail.com> <522554D6.4070000@oracle.com> <522584DD.8070401@nod.at> <20130903172244.GQ31381@wotan.suse.de> <52262980.2050406@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52262980.2050406@nod.at>
Organization: SUSE Labs
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 03, 2013 at 08:25:04PM +0200, Richard Weinberger wrote:
> >> Hmm, not fun.
> >> In my case I'm not using NFS or any other network filesystem.
> >> The OCFS2 is also used in local mode (no cluster).
> >>
> >> What really worries me is that this another proof that Oracles OCFS2 branch is out of sync with mainline.
> > 
> > Can you show me what branch you are talking about here?
> 
> https://oss.oracle.com/git/?p=ocfs2-1.4.git seems to contain fixes for years
> which are not mainline.

Ok just FYI I don't believe that to actually be the case - there might be
one or two fixes that were changed when ported to mainline and
there's certainly the possiblity that a mistake was made. But generally
fixes went from mainline into the 1.4 repository and not the other way.

That's not to say things haven't been slow on the Ocfs2 front lately or
anything, but I don't believe it to be the case that fixees are regularly
being put into an Oracle tree that haven't seen mainline.
	--Mark

--
Mark Fasheh
