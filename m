Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760181Ab3CIAcz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 19:32:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759955Ab3CIAcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 19:32:53 -0500
Date: Fri, 8 Mar 2013 19:32:48 -0500
From: Dave Jones <davej@redhat.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: ipc/testmsg GPF.
Message-ID: <20130309003248.GA6743@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Peter Hurley <peter@hurleysoftware.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20130307213819.GB19543@redhat.com>
 <1362788821.7755.12.camel@thor.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362788821.7755.12.camel@thor.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 07:27:01PM -0500, Peter Hurley wrote:
 > [ +Andrew Morton ]
 > 
 > On Thu, 2013-03-07 at 16:38 -0500, Dave Jones wrote:
 > > Trying to reproduce that nd_jump_link trace, but I keep hitting other bugs
 > > instead.  It's like whackamole. Except these are even more annoying
 > > than moles.
 > 
 > Dave,
 > I thought I copied you on the 'ipc MSG_COPY fixes' patchset that fixes
 > this. Or is this gp fault happening with that patchset?

I hadn't gotten around to applying them to my testing tree. 
Worth noting that of the dozens of oopses I've seen the last few days
I think I only saw this one once.

(Though I've narrowed my testing scope right now to try and tickle
 those fs/namei.c bugs, so it could just be that I'm not exercising
 the codepaths that caused the ipc bug)

	Dave

