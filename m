Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750898AbaGaMDb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 08:03:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58105 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbaGaMDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 08:03:30 -0400
Subject: Re: [PATCH 0/3] therm_windtunnel doesn't work properly on PowerMac
 G4
From: Jean Delvare <jdelvare@suse.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: kreijack@inwind.it, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1406797513.4935.182.camel@pasglop>
References: <53D95AAF.6030309@inwind.it> <1406770020.4935.166.camel@pasglop>
	 <20140731085211.5941bd33@endymion.delvare>
	 <1406797513.4935.182.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Thu, 31 Jul 2014 14:03:21 +0200
Message-ID: <1406808201.4596.4.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

Le Thursday 31 July 2014 à 19:05 +1000, Benjamin Herrenschmidt a écrit :
> On Thu, 2014-07-31 at 08:52 +0200, Jean Delvare wrote:
> > This leaves only two drivers still using the old binding model:
> > macintosh/therm_pm72 and sound/ppc/keywest. Could any of you please
> > convert these to the standard binding model so that I can finally get
> > rid of i2c_driver.attach_adapter? That would be wonderful.
> 
> therm_pm72 is deprecated, I wrote windfarm_pm72 to replace it so that I
> wouldn't have to convert the old one :-)
> 
> We can probably kill it now, it's been long enough.

Please do!

> As for the old audio one, that's the trickiest bit. I'm so completely
> swamped at the moment, I really haven't had a chance, on the other hand
> I'm not sure anybody will notice anymore if we just kill the bloody
> thing ...

Maybe we can make it depend on BROKEN, and remove the legacy API it was
using. If anyone notices and complains, they get to convert the driver.
Otherwise we just kill the driver after some time. Would that work for
you?

Thanks,
-- 
Jean Delvare
SUSE L3 Support

