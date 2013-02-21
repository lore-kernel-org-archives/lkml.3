Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab3BUSDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 13:03:19 -0500
Received: from mail.skyhub.de ([78.46.96.112]:46862 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754542Ab3BUSDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 13:03:17 -0500
Date: Thu, 21 Feb 2013 19:03:12 +0100
From: Borislav Petkov <bp@alien8.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH EDACv2 01/12] edac: add support for raw error reports
Message-ID: <20130221180312.GI4694@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Edac Mailing List <linux-edac@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <cover.1361459782.git.mchehab@redhat.com>
 <30b4b936bf5eb2a47613cd3d5a256e4e9c56e911.1361459782.git.mchehab@redhat.com>
 <20130221155337.GG4694@pd.tnic>
 <20130221130125.7f649d4c@redhat.com>
 <20130221160821.GH4694@pd.tnic>
 <20130221144759.6f960a39@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130221144759.6f960a39@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 02:47:59PM -0300, Mauro Carvalho Chehab wrote:
> Em Thu, 21 Feb 2013 17:08:21 +0100
> Borislav Petkov <bp@alien8.de> escreveu:
> 
> > On Thu, Feb 21, 2013 at 01:01:25PM -0300, Mauro Carvalho Chehab wrote:
> > > I did this way to to follow the "one patch per logical change rule".
> > > The rationale for this patch is to allow doing raw error reports,
> > > as needed by changeset 06/12.
> > 
> > Right, but you're adding a new function so why not add the right version
> > from the get-go? Otherwise the rule above would apply but not for new
> > code, right?
> 
> The rule also applies for both patches.
> 
> Except for making everybody's looking on this code to re-read all patches 
> and for me to rebase it again, I can't see any difference between what I
> posted and your proposal to move patch 10 to the beginning of the changeset.
> 
> Anyway, I did it at this separate branch, in order to preserve the previous
> ghes_v2 (also at the same repository):
> 	http://git.infradead.org/users/mchehab/edac.git/shortlog/refs/heads/ghes_v3
> 
> Patch 10/12 is now the first patch, and became this one:
> 	http://git.infradead.org/users/mchehab/edac.git/commit/c7ef7645544131b0750478d1cf94cdfa945c809d
> 
> Patch 01/12 is now the second one:
> 	http://git.infradead.org/users/mchehab/edac.git/commit/e7e248304c8ccf02b89e04c3b3b66006b993b5a7
> 
> Obviously, the ghes_edac part of 10/12 got fold into this patch:
> 	http://git.infradead.org/users/mchehab/edac.git/commit/bf45061af29e585506e8d3bfcda2f2b1e557281c
> 
> And a couple other patches got side-affected by this change with trivial
> conflicts (patches 9/12 and 11/12). Except for this change, v2 and v3 are 
> identical, so I won't re-post it.

Yep, looks good at a quick glance.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
