Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491AbaDMWHi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 18:07:38 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:47771 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbaDMWHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 18:07:36 -0400
Date: Mon, 14 Apr 2014 01:07:01 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Pascal COMBES <pascom@orange.fr>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Jarod Wilson <jarod@wilsonet.com>, Jingoo Han <jg1.han@samsung.com>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        linux-kernel@vger.kernel.org, Naren Sankar <nsankar@broadcom.com>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Scott Davilla <davilla@4pi.com>,
        Amarjargal Gundjalam <amarjargal16@gmail.com>,
        Robert Foss <dev@robertfoss.se>
Subject: Re: [PATCH v2 1/3] Fix alignement problems in
 drivers/staging/crystalhd/crystalhd_lnx.c
Message-ID: <20140413220701.GR4963@mwanda>
References: <534AAED2.7050205@orange.fr>
 <20140413154859.GA18189@kroah.com>
 <534AE0DE.6020404@orange.fr>
 <20140413210243.GK26890@mwanda>
 <1397424375.31896.7.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397424375.31896.7.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2014 at 11:26:15PM +0200, Paul Bolle wrote:
> On Mon, 2014-04-14 at 00:02 +0300, Dan Carpenter wrote:
> > The subeject should be:
> > 
> > [PATCH v2 1/3] Staging: crystalhd: Fix alignement in crystalhd_lnx.c
> > 
> > Please resend it.  Also you should use shorter subject lines.
> > 
> > "Fix coding style problem (cast with space) in drivers/staging/crystalhd/crystalhd_lnx.c"
> > 
> > This is too long.  Say:
> > 
> > "Remove a stray space character in crystalhd_lnx.c"
> 
> The commit explanation also was a copy of the subject line.

Huh?  No it wasn't.

> That
> suggests that the explanation can be dropped.

The long description was fine.  It included a copy of the error message
and everything.

> Many trivial fixes can
> (and should) be submitted without a commit explanation.
> 

Don't encourage people to leave out the commit message.  They can figure
out on their own when that is appropriate.  In my experience people only
err on the other side, by not commenting enough.  I've only rarely been
annoyed by a long description which was too long.

regards,
dan carpenter

