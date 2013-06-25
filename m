Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735Ab3FYMPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 08:15:17 -0400
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:35304 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab3FYMPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 08:15:15 -0400
Date: Tue, 25 Jun 2013 14:15:08 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [GIT PULL] s390 patches for the 3.9-rc6
Message-ID: <20130625141508.6c391fd8@mschwide>
In-Reply-To: <CACxGe6sYM8QPB-ZZkgB0+f81CZHULPi5zPAsWb5dzHiRgU+w6Q@mail.gmail.com>
References: <20130403172534.528d04c5@mschwide>
	<CACxGe6sYM8QPB-ZZkgB0+f81CZHULPi5zPAsWb5dzHiRgU+w6Q@mail.gmail.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062512-6892-0000-0000-000005842DEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jun 2013 13:09:51 +0100
Grant Likely <grant.likely@secretlab.ca> wrote:

> On Wed, Apr 3, 2013 at 4:25 PM, Martin Schwidefsky
> <schwidefsky@de.ibm.com> wrote:
> > Hi Linus,
> >
> > please pull from the 'for-linus' branch of
> >
> >         git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus
> >
> > to receive the following updates: Just a bunch of bugfixes.
> >
> > Heiko Carstens (4):
> >       drivers/Kconfig: add several missing GENERIC_HARDIRQS dependencies
> 
> Is anyone currently working on fixing this? s390 is the only
> architecture left that does not enable GENERIC_HARDIRQS. It's painful
> to keep adding dependencies on GENERIC_HARDIRQS to driver configs.

I am working on it. The hardest part is MSI irqs for PCI. Chances are
that I get it done for the merge window of 3.12.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

