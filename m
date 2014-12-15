Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177AbaLOOIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:08:50 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:61627 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbaLOOIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:08:48 -0500
Date: Mon, 15 Dec 2014 06:08:43 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Loic Pefferkorn <loic@loicp.eu>, gregkh@linuxfoundation.org,
        alan@linux.intel.com, jun.j.tian@intel.com, octavian.purdila@intel.com,
        nnk@google.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, apw@canonical.com, joe@perches.com
Subject: Re: [PATCH] checkpatch giving bogus advice (was staging: goldfish:
 Fix minor coding style)
Message-ID: <20141215140843.GA918@newt.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
	Loic Pefferkorn <loic@loicp.eu>, gregkh@linuxfoundation.org,
	alan@linux.intel.com, jun.j.tian@intel.com,
	octavian.purdila@intel.com, nnk@google.com,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	apw@canonical.com, joe@perches.com
References: <e2a3b3ccf85790c865683832698908458931be6a.1418487651.git.loic@loicp.eu>
 <20141213175518.GA28616@hudson.localdomain>
 <20141213182238.GA6979@iron>
 <20141213194647.GA30065@hudson.localdomain>
 <20141215114421.7389d32a@lxorguk.ukuu.org.uk>
 <20141215130346.GB18251@hudson.localdomain>
 <20141215134334.GE4856@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141215134334.GE4856@mwanda>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan,

On Mon, Dec 15, 2014 at 04:43:34PM +0300, Dan Carpenter wrote:
> On Mon, Dec 15, 2014 at 05:03:46AM -0800, Jeremiah Mahler wrote:
> > 
> > Or another way mentioned in K&R that produces a compile error
> > 
> >             if (NULL = x) 
> > 
> 
> Yes.  People used to write Yoda code back in the day.  Don't ever do
> this in the kernel.
> 
> 1) It looks stupid.

Agreed :-)

> 2) GCC will catch most == vs = bugs as Alan pointed out.
> 3) There are still some that sneak through because people put double
>    parenthesis around everything like "if ((foo = NULL) || (...)) {",
>    but checkpatch.pl and Smatch will catch those.
> 
> regards,
> dan carpenter
> 

-- 
- Jeremiah Mahler
