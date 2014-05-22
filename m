Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258AbaEVQ2B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 12:28:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44546 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869AbaEVQ2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 12:28:00 -0400
Date: Thu, 22 May 2014 18:27:56 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Flavio Leitner <fbl@redhat.com>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Flavio Leitner <fbl@sysclose.org>,
        lm-sensors@lm-sensors.org
Subject: Re: [PATCH] i8k: increase fan limit to 3
Message-ID: <20140522182756.04afd351@endymion.delvare>
In-Reply-To: <20140522151259.GC1001@roeck-us.net>
References: <1400725168-21358-1-git-send-email-fbl@redhat.com>
	<537D6FC8.5000105@roeck-us.net>
	<20140522082831.GA16167@alpha.franken.de>
	<20140522151259.GC1001@roeck-us.net>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2014 08:12:59 -0700, Guenter Roeck wrote:
> On Thu, May 22, 2014 at 10:28:31AM +0200, Thomas Bogendoerfer wrote:
> > On Wed, May 21, 2014 at 08:32:24PM -0700, Guenter Roeck wrote:
> > > On 05/21/2014 07:19 PM, Flavio Leitner wrote:
> > > >From: Flavio Leitner <fbl@sysclose.org>
> > > >
> > > >It is possible to increase left fan speed on a
> > > >DELL Precision 490n system up to 3.
> > > >
> > > >     value    fan rpm
> > > >       1      35460
> > > >       2      64740
> > > >       3      78510
> > > >
> > > Guess the speed factor 30 doesn't apply here.
> > 
> > on my vostro 1720 value 3 is default value and it looks like
> > it's sort of an auto mode.
> > 
> > BTW. the only fan in the system is on the left side, but shows up as
> > RigthFan. Wouldn't it be better to simply number the fans and let the
> > "real" labeling be done via sensors.conf ?
> > 
> I agree. Jean, any comments ? Is it ok to drop the fan labels ?

Yes it is, I had that it mind already, just I don't have the time to do
it.

-- 
Jean Delvare
SUSE L3 Support
