Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965247Ab3GLR51 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 13:57:27 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:37251 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933186Ab3GLR5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 13:57:24 -0400
Date: Fri, 12 Jul 2013 13:57:18 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        ksummit-2013-discuss@lists.linux-foundation.org
Subject: Re: [Ksummit-2013-discuss] When to push bug fixes to mainline
Message-ID: <20130712175718.GA342@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, stable@vger.kernel.org,
	ksummit-2013-discuss@lists.linux-foundation.org
References: <20130711214830.611455274@linuxfoundation.org>
 <20130712005023.GB31005@thunk.org>
 <20130712025745.GA24086@tuxdriver.com>
 <20130712033430.GA3798@kroah.com>
 <51E03AEE.5010403@zytor.com>
 <20130712172836.GA7627@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130712172836.GA7627@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 10:28:36AM -0700, Greg Kroah-Hartman wrote:
> On Fri, Jul 12, 2013 at 10:20:46AM -0700, H. Peter Anvin wrote:
> > On the subject of the stable tree: could we get a standard format for
> > requesting post-inclusion elevation of patches to stable status?  It
> > isn't all that unusual that the need for -stable is highlighted after a
> > patch has been included in a maintainer's tree, and rebasing to add
> > stable metadata annoys Linus.
> 
> After it's in Linus's tree, just send the git id of the patch to
> stable@vger.kernel.org, along with what stable tree(s) you want to see
> the patch backported to.
> 
> Documentation/stable_kernel_rules.txt should be pretty explicit about
> how to do this, but if not, patches to it are always welcome.

FWIW, Documentation/stable_kernel_rules.txt currently says that you
should send the patch.  I checked to see whether sending the git id
was sufficient, and upon reading stable_kernel_rules.txt, decided to
simply run git format-patch/git send-email of the commits in mainline.
Apparently no one seemed to mind....

					- Ted
