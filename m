Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbbAUTPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 14:15:44 -0500
Received: from service87.mimecast.com ([91.220.42.44]:57706 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbbAUTPg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 14:15:36 -0500
Date: Wed, 21 Jan 2015 19:15:31 +0000
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Andrew Jackson <Andrew.Jackson@arm.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "moinejf@free.fr" <moinejf@free.fr>
Subject: Re: [PATCH v2] drm/i2c: tda998x: Set the CEC I2C address based on
 the slave I2C address.
Message-ID: <20150121191531.GJ10762@e106497-lin.cambridge.arm.com>
References: <545C835D.1050008@arm.com>
 <20150121184405.GI10762@e106497-lin.cambridge.arm.com>
 <20150121184658.GX26493@n2100.arm.linux.org.uk>
MIME-Version: 1.0
In-Reply-To: <20150121184658.GX26493@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 21 Jan 2015 19:15:32.0430 (UTC) FILETIME=[A055BEE0:01D035AE]
X-MC-Unique: 115012119153401401
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 06:46:58PM +0000, Russell King - ARM Linux wrote:
> On Wed, Jan 21, 2015 at 06:44:05PM +0000, Liviu Dudau wrote:
> > On Fri, Nov 07, 2014 at 08:31:25AM +0000, Andrew Jackson wrote:
> > > The I2C address for the TDA9989 and TDA19989 is fixed at 0x34
> > > but the two LSBs of the TDA19988's address are set by two configuration
> > > pins on the chip.  Irrespective of the chip, the associated CEC
> > > peripheral's I2C address is based upon the main I2C address.
> > > 
> > > This patch avoids any special handling required to support
> > > systems that contain multiple TDA19988 devices on the same
> > > I2C bus.
> > > 
> > > Signed-off-by: Andrew Jackson <Andrew.Jackson@arm.com>
> > > Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> > 
> > Hi Andrew,
> > 
> > What is the status of this patch? Is it going to be pulled by anyone?
> 
> It's been sent to David.

Thanks, Russell!

Liviu

> 
> -- 
> FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
> according to speedtest.net.
> 

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

