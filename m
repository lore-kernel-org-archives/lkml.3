Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816AbaGaGwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 02:52:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51208 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752901AbaGaGwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 02:52:16 -0400
Date: Thu, 31 Jul 2014 08:52:11 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: kreijack@inwind.it, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] therm_windtunnel doesn't work properly on PowerMac
 G4
Message-ID: <20140731085211.5941bd33@endymion.delvare>
In-Reply-To: <1406770020.4935.166.camel@pasglop>
References: <53D95AAF.6030309@inwind.it>
	<1406770020.4935.166.camel@pasglop>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben, Goffredo,

On Thu, 31 Jul 2014 11:27:00 +1000, Benjamin Herrenschmidt wrote:
> On Wed, 2014-07-30 at 22:50 +0200, Goffredo Baroncelli wrote:
> > I am writing to you Jean and Benjamin because it seem that both 
> > worked on these items.
> > 
> > On a PowerMac G4 I noticed that between the kernel v3.2 and v3.14 I lost
> > the fan management.
> > 
> > I found on internet other references to this kind of problem [2]

Yay! Thanks a lot Goffredo! I've been waiting for this driver to be
finally converter to the standard device driver model for years,
literally. I'm very happy to finally see this happen :-)

The i2c_driver.attach_adapter method was marked for removal in
September 2011 so we are almost 3 year late on the schedule :-(

> Patches look good, thanks. Jean do you want to apply them or should I ?

Please pick them, they are totally macintosh-specific so they won't
interact with anything I have in my tree. Plus I can't even built-test
them.

This leaves only two drivers still using the old binding model:
macintosh/therm_pm72 and sound/ppc/keywest. Could any of you please
convert these to the standard binding model so that I can finally get
rid of i2c_driver.attach_adapter? That would be wonderful.

Thanks again,
-- 
Jean Delvare
SUSE L3 Support
