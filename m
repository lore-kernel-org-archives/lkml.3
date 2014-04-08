Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212AbaDHHEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 03:04:36 -0400
Received: from seketeli.net ([94.23.218.202]:54285 "EHLO ms.seketeli.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbaDHHEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 03:04:34 -0400
Date: Tue, 8 Apr 2014 09:05:25 +0200
From: Apelete Seketeli <apelete@seketeli.net>
To: Felipe Balbi <balbi@ti.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org,
        Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>,
        David Fries <David@Fries.net>,
        "Robert P. J. Day" <rpjday@crashcourse.ca>,
        Ben Hutchings <ben@decadent.org.uk>,
        Lars-Peter Clausen <lars@metafoo.de>, linux-kernel@vger.kernel.org,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [RESEND PATCH v2] documentation: docbook: document process of
 writing an musb glue layer
Message-ID: <20140408070525.GL10199@tao>
References: <20140405183636.GO22445@amegan>
 <20140405184205.GP22445@amegan>
 <534322B9.30605@infradead.org>
 <20140407230218.GA28921@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140407230218.GA28921@saruman.home>
X-Operating-System: Debian GNU/Linux 7
X-URL: http://apelete.seketeli.net
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Apr-07-2014 at 06:02:18 PM -0500, Felipe Balbi wrote:
> Hi,
> 
> On Mon, Apr 07, 2014 at 03:12:09PM -0700, Randy Dunlap wrote:
> > On 04/05/2014 11:42 AM, Apelete Seketeli wrote:
> > > Document the process of writing an musb glue layer by taking the
> > > Ingenic JZ4740 glue layer as an example, as it seems more simple than
> > > most glue layers due to the basic feature set of the JZ4740 USB device
> > > controller.
> > > 
> > > Signed-off-by: Apelete Seketeli <apelete@seketeli.net>
> > 
> > Hi,
> > 
> > You should be cc-ing the musb maintainer and the USB mailing list (so now done).

That was my intent in the first place -- I mentioned the USB mailing
list in the cover letter and then forgot to actually cc the people
over there. Thanks for taking care of that.

> > Felipe should probably be the person to merge this unless he wants me
> > to do it...
> 
> I'll merge it, just resend once -rc1 is out. Thanks

Ok, I'll resend once -rc1 is out. Thanks for your time.

Cheers.
-- 
        Apelete
