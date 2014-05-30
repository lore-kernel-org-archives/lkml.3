Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbaE3T61 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 15:58:27 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:51048 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbaE3T60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 15:58:26 -0400
Date: Fri, 30 May 2014 12:58:21 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Sebastian Reichel <sre@kernel.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 0/4] tsc2005 DT binding
Message-ID: <20140530195821.GA27692@core.coreip.homeip.net>
References: <1400693774-21306-1-git-send-email-sre@kernel.org>
 <20140529133356.GA4716@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140529133356.GA4716@earth.universe>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 03:33:57PM +0200, Sebastian Reichel wrote:
> On Wed, May 21, 2014 at 07:36:10PM +0200, Sebastian Reichel wrote:
> > This adds device tree support for the tsc2005 touchscreen
> > controller, which is currently only used by the Nokia N900
> > board.
> > 
> > The patch does not update the reset pin handling for platform
> > data based probe to avoid merge conflicts. The n900 platform
> > code will be removed in the near future (3.17?) and the driver
> > can be simplified once that has happened.
> > 
> > Changes since v3 [0]:
> >  * Move common touchscreen DT handling code into its own file
> >  * Add regulator support to tsc2005 driver
> >  * Added N900 DTS patch for completeness. It should go via
> >    Tony's Tree of course.
> 
> ping! It would be nice to have this in 3.16, since it makes
> the N900 usable with the mainline kernel when booted in DT
> mode. The DT bindings haven't changed for more than 3 weeks,
> so we don't need to wait longer for feedback from the DT
> maintainers AFAIK.

Sebastian,

I applied the series, could you please take a peek at my 'next' branch
to make sure I did not miss anything?

Thanks.

-- 
Dmitry
