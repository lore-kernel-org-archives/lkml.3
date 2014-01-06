Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499AbaAFBBm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 20:01:42 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:56937 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbaAFBBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 20:01:41 -0500
Date: Mon, 6 Jan 2014 01:01:36 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Theodore Ts'o" <tytso@mit.edu>, bulk88 <bulk88@hotmail.com>,
        Antti Heikkinen <antti.heikkinen.4@gmail.com>,
        linux-kernel@vger.kernel.org, advocacy@perl.org, beginners@perl.org
Subject: Re: Propose for LINUX kernel and PERL
Message-ID: <20140106010136.GH10323@ZenIV.linux.org.uk>
References: <CAM__s2Bk=Hgzm3-f7N=A032PxUV6N87=42qZ=7kt7u8d_Ny5gg@mail.gmail.com>
 <BLU0-SMTP270AA353C093297F94C7B85DFB40@phx.gbl>
 <20140105234307.GA16071@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140105234307.GA16071@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 05, 2014 at 06:43:07PM -0500, Theodore Ts'o wrote:

> > Since Perl is Turing complete you can run the Linux kernel inside
> > Perl. Although Perl doesn't run in kernel mode ATM, I don't see why
> > I can't be ported to be a LKM, maybe with RPC to glibc. You could
> > also have Perl running as user mode driver or some kind daemon with
> > calls from a kernel driver to the user space daemon Perl. You can
> > use Perl version 5 or 6.
> 
> My favorite suggestion, going back several decades to the early 90's,
> was those who suggested porting BSD 4.3 to Emacs LISP, so that you
> could run your entire system under GNU Emacs.  :-)

ISAGN: drivers/staging/vi[1].  As a TTY line discipline.  Surely once that
thing is in, somebody will come up with Perl interpreter in vi macros.
And once _that_ is done, the rest will be easy...

[1] or drivers/staging/sam, for extra credits - as far as macros go,
it'd be more convenient implementation platform...
