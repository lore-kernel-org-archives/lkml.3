Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751260Ab3KNFrz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 00:47:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45567 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab3KNFrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 00:47:52 -0500
Date: Thu, 14 Nov 2013 14:47:50 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Doug Thompson <dougthompson@xmission.com>
Cc: Johannes Thumshirn <johannes.thumshirn@men.de>,
        Borislav Petkov <bp@suse.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Robert Richter <rric@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-edac@vger.kernel.org
Subject: Re: [GIT PULL] mpc85xx_edac changes for 3.13
Message-ID: <20131114054750.GA27791@kroah.com>
References: <20131112161901.GA15637@jtlinux>
 <CA+55aFzJhyo8bKBchYq0Q=rwPv_-v-xWgOKWxKBcSBycMZcmTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzJhyo8bKBchYq0Q=rwPv_-v-xWgOKWxKBcSBycMZcmTg@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 02:41:24PM +0900, Linus Torvalds wrote:
> On Wed, Nov 13, 2013 at 1:19 AM, Johannes Thumshirn
> <johannes.thumshirn@men.de> wrote:
> >
> >   git://github.com/morbidrsa/linux.git tags/mpc85xx-edac-for-3.13
> 
> Ok, it's a signed tag, but I haven't pulled from you before (all the
> commits I see seem to have gone through Greg), and I don't recognize
> any of the signatures on your tag.
> 
> That, together with not really knowing the whole edac area, makes me
> not wonderfully happy about pulling directly. I a.lso see another edac
> pull request in my mailbox, making me suspect that there are
> maintainership problems (historically I've been getting the code
> either though Greg, Borislav or Mauro). So I'd also like to make sure
> that I at least _know_ about any disputes going on in this area?
> 
> So before I pull this, I'd quickly like to validate the gpg key, and
> am cc'ing more people to see if I'm stepping into some political
> nightmare. I can be ok with that, but I want to do so knowingly, not
> blindly..

I thought Doug was the maintainer of EDAC (now added to the to:), and
Mauro has been doing a bunch of work there, while he was at Red Hat.  I
haven't taken any EDAC patches in a while since Mauro started cleaning
up the area, so I don't know anything about this, sorry.

Doug?

