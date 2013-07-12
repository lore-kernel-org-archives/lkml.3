Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965145Ab3GLR2i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 13:28:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52512 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932650Ab3GLR2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 13:28:37 -0400
Date: Fri, 12 Jul 2013 10:28:36 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org,
        ksummit-2013-discuss@lists.linux-foundation.org
Subject: Re: [Ksummit-2013-discuss] When to push bug fixes to mainline
Message-ID: <20130712172836.GA7627@kroah.com>
References: <20130711214830.611455274@linuxfoundation.org>
 <20130712005023.GB31005@thunk.org>
 <20130712025745.GA24086@tuxdriver.com>
 <20130712033430.GA3798@kroah.com>
 <51E03AEE.5010403@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E03AEE.5010403@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 10:20:46AM -0700, H. Peter Anvin wrote:
> On the subject of the stable tree: could we get a standard format for
> requesting post-inclusion elevation of patches to stable status?  It
> isn't all that unusual that the need for -stable is highlighted after a
> patch has been included in a maintainer's tree, and rebasing to add
> stable metadata annoys Linus.

After it's in Linus's tree, just send the git id of the patch to
stable@vger.kernel.org, along with what stable tree(s) you want to see
the patch backported to.

Documentation/stable_kernel_rules.txt should be pretty explicit about
how to do this, but if not, patches to it are always welcome.

Yes, this requires you to remember to do this after it hits Linus's
tree, so you could do like David does for networking, and keep a
seperate tree to send to me specifically for stable patches.  I think he
uses patchwork, but I know others use git for this, and that's fine as
well.

greg k-h
