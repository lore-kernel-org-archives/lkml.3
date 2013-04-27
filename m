Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab3D0PYJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 11:24:09 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:39355 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab3D0PYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 11:24:07 -0400
Date: Sat, 27 Apr 2013 17:24:00 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: linux-next: Tree for Apr 26
Message-ID: <20130427152400.GB3355@free.fr>
References: <517A4FC1.3070605@suse.cz>
 <20130426100435.GA28733@sepie.suse.cz>
 <CA+icZUVOfB2JuL1xh1EO1hTP_eOkntYFKsUJ0Zp6VZqn09NABA@mail.gmail.com>
 <CA+icZUWNVEsiTs6u_2R9krb45ub4t-pZj_VEPRmrX2c4DzwfmA@mail.gmail.com>
 <CA+icZUXSsqN1iE3ttQakvpZqG-oOL9NR6RMUezB7LGeUw3d00Q@mail.gmail.com>
 <517A6033.5060103@suse.cz>
 <517A615D.9020400@suse.cz>
 <20130426220131.GC5100@free.fr>
 <517B762D.8030409@suse.cz>
 <CA+icZUWeQ_UcH4mFPr64Zm9Z48n1pen1Jh3LO3P4qVFKSq8kLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUWeQ_UcH4mFPr64Zm9Z48n1pen1Jh3LO3P4qVFKSq8kLw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sedat, All,

On Sat, Apr 27, 2013 at 01:30:33PM +0200, Sedat Dilek wrote:
> On Sat, Apr 27, 2013 at 8:54 AM, Michal Marek <mmarek@suse.cz> wrote:
> > That (silent)oldconfig with stdin redirection throws an error if it
> > encounters a new option is expected and correct. The bug here is that
> > _normal_ oldconfig run apparently does not set all the options. I.e.
> >
> > $ yes "" | make oldconfig; make silentoldconfig </dev/null
> >
> > should always pass.
> >
> 
> Yupp. That should be always tested... before sending patches and
> committing to a repo :-).
> Anyway, thanks for taking care and solving fast to all involved folks!

Yep, that kind of command was what I was missing to check for regression
on this patch. Now, I have someting to test. Thanks.

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
