Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170AbaGOJTM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:19:12 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:32938 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497AbaGOJTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:19:09 -0400
Date: Tue, 15 Jul 2014 11:19:03 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: Arnd Bergmann <arnd@arndb.de>, lkml <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 07/38] Delete unused Kbuild files in include/*
Message-ID: <20140715091902.GA3290@ravnborg.org>
References: <20140714150609.GA28358@ravnborg.org>
 <1405350546-28467-1-git-send-email-sam@ravnborg.org>
 <1405350546-28467-7-git-send-email-sam@ravnborg.org>
 <53C4EF1B.2050506@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C4EF1B.2050506@imgtec.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 10:06:35AM +0100, James Hogan wrote:
> On 14/07/14 16:08, Sam Ravnborg wrote:
> > The following files are not used - and they serve no purpose.
> > Delete them.
> > 
> > Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> > Cc: David Howells <dhowells@redhat.com>
> > ---
> >  include/Kbuild         | 2 --
> >  include/scsi/fc/Kbuild | 0
> >  include/video/Kbuild   | 0
> >  3 files changed, 2 deletions(-)
> >  delete mode 100644 include/Kbuild
> >  delete mode 100644 include/scsi/fc/Kbuild
> >  delete mode 100644 include/video/Kbuild
> 
> include/asm-generic/Kbuild.asm could go too since it isn't included
> anywhere.

Good catch. I recall that I was wondering what the purpose of the file
was but forgot about it again.
Will delete in in v2 of this patch-set.

	Sam
