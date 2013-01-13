Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592Ab3AMVXV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 16:23:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57636 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754643Ab3AMVXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 16:23:21 -0500
Date: Sun, 13 Jan 2013 22:23:19 +0100
From: Michal Marek <mmarek@suse.cz>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Andreas Schwab <schwab@linux-m68k.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/tags.sh: Fix regex syntax for etags
Message-ID: <20130113212319.GA3699@pobox.suse.cz>
References: <20121227184034.GA2982@debian.debian> <CABuSbKbk5DdhvuwYUeLkm=eub1CsSaOB_oX7bkBZcAV_MNsSdg@mail.gmail.com> <CAK7N6vpvLrAb=sZitaEBQ6Fx4K5ehGg+LTU70hiVK=1RdE4WwQ@mail.gmail.com> <CAOUxTKNgs4N-M5RR6YHyGeXQqRrg0_CJpxgT2OmN_buEP+jbjQ@mail.gmail.com> <CAK7N6vqw+DVSVaCXqiQBVa_d2o-rg-oA5t8+6WNaZ9Mb_iQqdw@mail.gmail.com> <87a9syhbma.fsf@xmission.com> <20121228130734.GB13224@x1.alien8.de> <Pine.LNX.4.64.1212282321370.2539@axis700.grange> <m2han5wza1.fsf_-_@igel.home> <alpine.LNX.2.00.1212290022100.32254@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1212290022100.32254@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 29, 2012 at 12:22:44AM +0100, Jesper Juhl wrote:
> On Sat, 29 Dec 2012, Andreas Schwab wrote:
> 
> > Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
> > ---
> >  scripts/tags.sh | 50 +++++++++++++++++++++++++-------------------------
> >  1 file changed, 25 insertions(+), 25 deletions(-)
[...] 
> This works for me. Thanks.
> 
> Tested-by: Jesper Juhl <jj@chaosbits.net>

Applied to kbuild.git#misc, thanks.

Michal
