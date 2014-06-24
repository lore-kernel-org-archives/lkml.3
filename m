Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbaFXHAL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 03:00:11 -0400
Received: from smtp-69.nebula.fi ([83.145.220.69]:40185 "EHLO smtp.nebula.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259AbaFXHAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 03:00:09 -0400
Date: Tue, 24 Jun 2014 09:59:42 +0300
From: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Franck Jullien <franck.jullien@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, plagnioj@jcrosoft.com
Subject: Re: [PATCH] video: OF display-timings support for ocfb
Message-ID: <20140624065941.GA896@chokladfabriken.org>
References: <1402517871-27503-1-git-send-email-franck.jullien@gmail.com>
 <53A81720.2050507@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A81720.2050507@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 03:01:36PM +0300, Tomi Valkeinen wrote:
> On 11/06/14 23:17, Franck Jullien wrote:
> > Signed-off-by: Franck Jullien <franck.jullien@gmail.com>
> > ---
> >  drivers/video/fbdev/Kconfig |    2 ++
> >  drivers/video/fbdev/ocfb.c  |   31 ++++++++++++++++++++++++++-----
> >  2 files changed, 28 insertions(+), 5 deletions(-)
> 
> You need to add binding documentation if you add new things to the
> driver's DT support. Actually, we seem to be missing the the binding
> documentation totally, even if the driver has 'of_device_id' table...
> 

Right, I'll take the blame for the missing driver binding documentation,
I'll write something up and post a patch for that.
But, where should it go?
Documentation/devicetree/bindings/video/
or
Documentation/devicetree/bindings/fb/

Stefan
