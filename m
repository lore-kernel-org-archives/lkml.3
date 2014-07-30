Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbaG3OJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 10:09:33 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:40171 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbaG3OJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 10:09:32 -0400
Date: Wed, 30 Jul 2014 17:09:14 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/19 v2] staging: comedi: amplc_pci230: remove
 unnecessary braces
Message-ID: <20140730140914.GK4856@mwanda>
References: <1406635107-27950-14-git-send-email-abbotti@mev.co.uk>
 <1406721227-8144-1-git-send-email-abbotti@mev.co.uk>
 <20140730134153.GJ4856@mwanda>
 <53D8FB53.3050501@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D8FB53.3050501@mev.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 03:04:03PM +0100, Ian Abbott wrote:
> On 2014-07-30 14:41, Dan Carpenter wrote:
> >On Wed, Jul 30, 2014 at 12:53:47PM +0100, Ian Abbott wrote:
> >>Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
> >>---
> >>v2: Be less aggressive in brace removal.  Keep them for outer nested
> >>'if's.  Keep them in outer control statements where the inner control
> >>statement uses braces.
> >
> >Really every multi-line indent should have braces for readability.  This
> >isn't documented anywhere, but it's normal kernel style and Greg prefers
> >it for staging as well but I can't find the URL on google where he
> >mentioned that.
> 
> With this version of the patch, amplc_pci230.c conforms to that --
> as long as you don't count comments, or splitting a simple statement
> across multiple lines to fit within 80 columns, e.g.:
> 
> 			if (foo)
> 				/* do this */
> 				bar = baz +
> 				      qux;

Heh...  I am counting comments and broken lines, though.  It's not a
totally strict rule and it's especially not strict for broken lines.
But we would prefer braces in those situations.

regards,
dan carpenter

