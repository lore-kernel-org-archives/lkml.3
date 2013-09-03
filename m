Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089Ab3ICRWr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 13:22:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46425 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757606Ab3ICRWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 13:22:45 -0400
Date: Tue, 3 Sep 2013 10:22:44 -0700
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
Message-ID: <20130903172244.GQ31381@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <CAFLxGvwLJs0ZrOZN-g=fCDEN4eAOQMjW_Nojm9fm5Rq0GKk9AQ@mail.gmail.com> <522554D6.4070000@oracle.com> <522584DD.8070401@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <522584DD.8070401@nod.at>
Organization: SUSE Labs
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 03, 2013 at 08:42:37AM +0200, Richard Weinberger wrote:
> Hi!
> 
> Am 03.09.2013 05:17, schrieb Jeff Liu:
> > Hello,
> > 
> > It seems like Sunil has fixed a similar issue against ocfs2-1.4
> > several years ago:
> > https://oss.oracle.com/git/?p=ocfs2-1.4.git;a=commitdiff_plain;h=2fd250839d0f5073af8d42e97f1db74beb621674;hp=e882faf84930431524f84598caea7d4e9a9529c5
> > https://oss.oracle.com/git/?p=ocfs2-1.4.git;a=commitdiff_plain;h=eccff85213d4c2762f787d9e7cb1503042ba75b9;hp=edc147473ffd9c03790dc4502b893823f44a9ec4
> > 
> > The old bug ticket for the discussion:
> > https://oss.oracle.com/bugzilla/show_bug.cgi?id=1235
> > 
> > This fix is specifically for ocfs2-1.4, but Mark once mentioned that
> > the BUG() there can be removed if we have a good explanation for this
> > sort of behavior, is it time to have it in mainline?
> 
> Hmm, not fun.
> In my case I'm not using NFS or any other network filesystem.
> The OCFS2 is also used in local mode (no cluster).
> 
> What really worries me is that this another proof that Oracles OCFS2 branch is out of sync with mainline.

Can you show me what branch you are talking about here?
	--Mark

--
Mark Fasheh
