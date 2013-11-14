Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554Ab3KNFlo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 00:41:44 -0500
Received: from mail-vb0-f47.google.com ([209.85.212.47]:41647 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab3KNFlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 00:41:25 -0500
MIME-Version: 1.0
In-Reply-To: <20131112161901.GA15637@jtlinux>
References: <20131112161901.GA15637@jtlinux>
Date: Thu, 14 Nov 2013 14:41:24 +0900
X-Google-Sender-Auth: kJlxgDPB9Y39KzVYUA3KnEpJhMA
Message-ID: <CA+55aFzJhyo8bKBchYq0Q=rwPv_-v-xWgOKWxKBcSBycMZcmTg@mail.gmail.com>
Subject: Re: [GIT PULL] mpc85xx_edac changes for 3.13
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Johannes Thumshirn <johannes.thumshirn@men.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Borislav Petkov <bp@suse.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Robert Richter <rric@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-edac@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 1:19 AM, Johannes Thumshirn
<johannes.thumshirn@men.de> wrote:
>
>   git://github.com/morbidrsa/linux.git tags/mpc85xx-edac-for-3.13

Ok, it's a signed tag, but I haven't pulled from you before (all the
commits I see seem to have gone through Greg), and I don't recognize
any of the signatures on your tag.

That, together with not really knowing the whole edac area, makes me
not wonderfully happy about pulling directly. I a.lso see another edac
pull request in my mailbox, making me suspect that there are
maintainership problems (historically I've been getting the code
either though Greg, Borislav or Mauro). So I'd also like to make sure
that I at least _know_ about any disputes going on in this area?

So before I pull this, I'd quickly like to validate the gpg key, and
am cc'ing more people to see if I'm stepping into some political
nightmare. I can be ok with that, but I want to do so knowingly, not
blindly..

                Linus
