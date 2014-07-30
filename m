Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbaG3Xxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 19:53:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42718 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbaG3Xx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 19:53:29 -0400
Date: Wed, 30 Jul 2014 16:53:01 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Hartley Sweeten <HartleyS@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>, Dan Carpenter <dan.carpenter@oracle.com>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 13/19 v2] staging: comedi: amplc_pci230: remove
 unnecessary braces
Message-ID: <20140730235301.GA26175@kroah.com>
References: <1406635107-27950-14-git-send-email-abbotti@mev.co.uk>
 <1406721227-8144-1-git-send-email-abbotti@mev.co.uk>
 <20140730134153.GJ4856@mwanda>
 <53D8FB53.3050501@mev.co.uk>
 <20140730140914.GK4856@mwanda>
 <53D900DD.6060006@mev.co.uk>
 <DC148C5AA1CEBA4E87973D432B1C2D8825F2A3C2@P3PWEX4MB008.ex4.secureserver.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DC148C5AA1CEBA4E87973D432B1C2D8825F2A3C2@P3PWEX4MB008.ex4.secureserver.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 04:15:23PM +0000, Hartley Sweeten wrote:
> On Wednesday, July 30, 2014 7:28 AM, Ian Abbott wrote:
> > On 2014-07-30 15:09, Dan Carpenter wrote:
> >> On Wed, Jul 30, 2014 at 03:04:03PM +0100, Ian Abbott wrote:
> >>> On 2014-07-30 14:41, Dan Carpenter wrote:
> >>>> On Wed, Jul 30, 2014 at 12:53:47PM +0100, Ian Abbott wrote:
> >>>>> Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
> >>>>> ---
> >>>>> v2: Be less aggressive in brace removal.  Keep them for outer nested
> >>>>> 'if's.  Keep them in outer control statements where the inner control
> >>>>> statement uses braces.
> >>>>
> >>>> Really every multi-line indent should have braces for readability.  This
> >>>> isn't documented anywhere, but it's normal kernel style and Greg prefers
> >>>> it for staging as well but I can't find the URL on google where he
> >>>> mentioned that.
> >>>
> >>> With this version of the patch, amplc_pci230.c conforms to that --
> >>> as long as you don't count comments, or splitting a simple statement
> >>> across multiple lines to fit within 80 columns, e.g.:
> >>>
> >>> 			if (foo)
> >>> 				/* do this */
> >>> 				bar = baz +
> >>> 				      qux;
> >>
> >> Heh...  I am counting comments and broken lines, though.  It's not a
> >> totally strict rule and it's especially not strict for broken lines.
> >> But we would prefer braces in those situations.
> >
> > If necessary, patches 13 and 19 can be dropped entirely.
> 
> That might be best for now.
> 
> The rest of the series applies fine with them dropped.

Now dropped :)
