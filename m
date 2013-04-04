Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760780Ab3DDNC3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 09:02:29 -0400
Received: from mail.active-venture.com ([67.228.131.205]:61902 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760141Ab3DDNC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 09:02:27 -0400
X-Originating-IP: 108.223.40.66
Date: Thu, 4 Apr 2013 06:02:25 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jean Delvare <khali@linux-fr.org>, Mike Frysinger <vapier@gentoo.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Blackfin: bf537: rename "CONFIG_ADT75"
Message-ID: <20130404130225.GA3145@roeck-us.net>
References: <1365071466.1830.29.camel@x61.thuisdomein>
 <20130404134003.016dcee3@endymion.delvare>
 <20130404120734.GA23162@roeck-us.net>
 <1365080383.1830.46.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365080383.1830.46.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 02:59:43PM +0200, Paul Bolle wrote:
> On Thu, 2013-04-04 at 05:07 -0700, Guenter Roeck wrote:
> > On Thu, Apr 04, 2013 at 01:40:03PM +0200, Jean Delvare wrote: 
> > > This breakage is telling us something about the weird approach taken in
> > > this file, methinks.
> > > 
> > Yes, they have persistent problems with renamed or moved drivers. I somewhat
> > understood the need for SPI chips, but even there it seemed to me there should
> > be a better solution.
> 
> The output of the (local) scripts I use mention about a dozen more
> (possible) problems in both Blackfin's stamp.c files. I'm roughly
> working my way back in git history, slowly, so those problems are
> probably older.
> 
> Since I know from previous cleaning up efforts that the Blackfin people
> know they have non-working code (eg, code not actually buildable since
> it has no working Kconfig support) I do not give Blackfin much priority.
> But this patch (and the other two related to the v3.2 release) were
> obvious oversights that I could as well fix right away.
> 
Makes me shiver ...

Guenter
