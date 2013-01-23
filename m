Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab3AWJ3H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 04:29:07 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:39479 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754187Ab3AWJ3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 04:29:05 -0500
Message-ID: <1358933288.6252.170.camel@cumari.coelho.fi>
Subject: Re: [PATCH] Revert "drivers/misc/ti-st: remove gpio handling"
From: Luciano Coelho <coelho@ti.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Tony Lindgren <tony@atomide.com>, <gregkh@linuxfoundation.org>,
        <balbi@ti.com>, <linux-kernel@vger.kernel.org>
Date: Wed, 23 Jan 2013 11:28:08 +0200
In-Reply-To: <50FFAB9B.4040408@ti.com>
References: <1358766762-24405-1-git-send-email-coelho@ti.com>
	   <20130122201453.GR22517@atomide.com>
	  <1358890299.6252.166.camel@cumari.coelho.fi> <50FFA7A9.9040709@ti.com>
	  <50FFA7F5.1000104@ti.com> <1358932452.6252.169.camel@cumari.coelho.fi>
	 <50FFAB9B.4040408@ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-23 at 10:21 +0100, Peter Ujfalusi wrote:
> On 01/23/2013 10:14 AM, Luciano Coelho wrote:
> > Yes, most likely we can use usleep or something.  I'll look into that as
> > part of my clean-up series. ;)
> 
> I would suggest to use usleep_range() instead of usleep() if you can.

Yes, probably something like that.  This doesn't need to be very
accurate, but it must be just long enough.

--
Luca.

