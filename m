Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbaGZUU6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 16:20:58 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:55533 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbaGZUU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 16:20:57 -0400
Date: Sat, 26 Jul 2014 22:20:55 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: "Theodore Ts'o" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        Jakub Jelinek <jakub@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Debian GCC Maintainers <debian-gcc@lists.debian.org>,
        Debian Kernel Team <debian-kernel@lists.debian.org>
Subject: Re: Random panic in load_balance() with 3.16-rc
Message-ID: <20140726202055.GC21842@x4>
References: <53D064C7.5050807@daenzer.net>
 <CA+55aFyJhqiPv0kQ+51=Ei-zaAO+0JszxtnEyx-Gbto3SE00xw@mail.gmail.com>
 <53D1B1EF.7030603@daenzer.net>
 <20140725035527.GA30108@pg-vmw-gw1>
 <20140725140237.GB32669@home.goodmis.org>
 <CA+55aFzOoJzqJ=4RVPEBfscA8oRdr5Nv7fKx9aXYw2+frkuhwA@mail.gmail.com>
 <CA+55aFyHU4Gwk6ASTuOgh3eFPshkgy1s5zc4p7f01DwrYddFOw@mail.gmail.com>
 <CA+55aFxaXPqyDJv-SNu6Giy3eKCu_SY1wof1NaNnPTbtF9RbXQ@mail.gmail.com>
 <20140726193557.GA21842@x4>
 <20140726195503.GJ6725@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140726195503.GJ6725@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014.07.26 at 15:55 -0400, Theodore Ts'o wrote:
> On Sat, Jul 26, 2014 at 09:35:57PM +0200, Markus Trippelsdorf wrote:
> > 
> > But fortunately the workaround for the new inode.c bug is the same as
> > for the original bug: -fno-var-tracking-assignments. 
> > 
> > It would make sense to enabled it unconditionally for all debug
> > configurations for now.
> 
> What's the downside of enabling this unconditionally on a compiler
> with the bug fixed?  I assume a certain amount of optimization will
> lost, but is it significant/measurable?

Only the quality of the debug info would suffer a bit.

-- 
Markus
