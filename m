Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490AbaEaMGl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 08:06:41 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:50510 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558AbaEaMGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 08:06:40 -0400
Date: Sat, 31 May 2014 15:05:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] driver core/platform: remove unused implicit padding in
 platform_object
Message-ID: <20140531120526.GL15585@mwanda>
References: <1401480167-15091-1-git-send-email-ydroneaud@opteya.com>
 <20140530201054.GF17724@mwanda>
 <1401523299.15490.6.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401523299.15490.6.camel@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 31, 2014 at 10:01:39AM +0200, Yann Droneaud wrote:
> Hi Dan,
> 
> Le vendredi 30 mai 2014 à 23:10 +0300, Dan Carpenter a écrit :
> > This changelog doesn't match the patch.
> > 
> 
> Hum, let me guess .... I've failed to set the proper subject prefix
> to add v6 suffic to PATCH: 
> I've changed the patch title since v5 (from Emil Goode)... so it's like
> a new one.
> 
> Is it really necessary to resend the patch ?

Oh.  Sorry, I didn't understand what you were trying to say...  You're
right.

For some reason I just looked at the patch first and then I started
reading the changelog and got to the bit about GCC on ARM and said
thought have been describing a different change without reading the
rest.  This was my bad.  I should have read more carefully.

Very thourough patch description.  :)

regards,
dan carpenter

