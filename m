Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbaDMWqD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 18:46:03 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:51346 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbaDMWqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 18:46:01 -0400
Date: Mon, 14 Apr 2014 01:45:28 +0300
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
Message-ID: <20140413224528.GS4963@mwanda>
References: <534AAED2.7050205@orange.fr>
 <20140413154859.GA18189@kroah.com>
 <534AE0DE.6020404@orange.fr>
 <20140413210243.GK26890@mwanda>
 <1397424375.31896.7.camel@x220>
 <20140413220701.GR4963@mwanda>
 <1397427183.31896.13.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397427183.31896.13.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 12:13:03AM +0200, Paul Bolle wrote:
> On Mon, 2014-04-14 at 01:07 +0300, Dan Carpenter wrote:
> > The long description was fine.  It included a copy of the error message
> > and everything.
> 
> This is what I saw in the body of the message above the "---" line:
>     From: Pascal COMBES <pascom@orange.fr>
> 
>     Fix alignement problems in drivers/staging/crystalhd/crystalhd_lnx.c.
> 
>     Signed-off-by: Pascal COMBES <pascom@orange.fr>
> 
> Are you and I looking at different patches?


Yeah.  I was looking at patch 2 where the space was removed.

regards,
dan carpenter

