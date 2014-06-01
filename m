Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583AbaFAIAk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 04:00:40 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:5860 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbaFAIAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 04:00:38 -0400
Message-ID: <1401609616.17059.2.camel@localhost.localdomain>
Subject: Re: [PATCH] driver core/platform: remove unused implicit padding in
 platform_object
From: Yann Droneaud <ydroneaud@opteya.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Yann Droneaud <ydroneaud@opteya.com>
Date: Sun, 01 Jun 2014 10:00:16 +0200
In-Reply-To: <20140531120526.GL15585@mwanda>
References: <1401480167-15091-1-git-send-email-ydroneaud@opteya.com>
	 <20140530201054.GF17724@mwanda>
	 <1401523299.15490.6.camel@localhost.localdomain>
	 <20140531120526.GL15585@mwanda>
Organization: OPTEYA
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

Le samedi 31 mai 2014 à 15:05 +0300, Dan Carpenter a écrit :
> On Sat, May 31, 2014 at 10:01:39AM +0200, Yann Droneaud wrote:
> > Le vendredi 30 mai 2014 à 23:10 +0300, Dan Carpenter a écrit :
> > > This changelog doesn't match the patch.
> > > 
> > 
> > Hum, let me guess .... I've failed to set the proper subject prefix
> > to add v6 suffic to PATCH: 
> > I've changed the patch title since v5 (from Emil Goode)... so it's like
> > a new one.
> > 
> > Is it really necessary to resend the patch ?
> 
> Oh.  Sorry, I didn't understand what you were trying to say...  You're
> right.
> 

Sorry about that.

If it's unclear, I should modify the commit message.

> For some reason I just looked at the patch first and then I started
> reading the changelog and got to the bit about GCC on ARM and said
> thought have been describing a different change without reading the
> rest.  This was my bad.  I should have read more carefully.
> 
> Very thourough patch description.  :)
> 

Thank you.

Regards.

-- 
Yann Droneaud
OPTEYA


