Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbaEVI4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 04:56:55 -0400
Received: from elvis.franken.de ([193.175.24.41]:56350 "EHLO elvis.franken.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621AbaEVI4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 04:56:53 -0400
X-Greylist: delayed 1665 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 May 2014 04:56:53 EDT
Date: Thu, 22 May 2014 10:28:31 +0200
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Flavio Leitner <fbl@redhat.com>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Flavio Leitner <fbl@sysclose.org>
Subject: Re: [PATCH] i8k: increase fan limit to 3
Message-ID: <20140522082831.GA16167@alpha.franken.de>
References: <1400725168-21358-1-git-send-email-fbl@redhat.com>
 <537D6FC8.5000105@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537D6FC8.5000105@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 08:32:24PM -0700, Guenter Roeck wrote:
> On 05/21/2014 07:19 PM, Flavio Leitner wrote:
> >From: Flavio Leitner <fbl@sysclose.org>
> >
> >It is possible to increase left fan speed on a
> >DELL Precision 490n system up to 3.
> >
> >     value    fan rpm
> >       1      35460
> >       2      64740
> >       3      78510
> >
> Guess the speed factor 30 doesn't apply here.

on my vostro 1720 value 3 is default value and it looks like
it's sort of an auto mode.

BTW. the only fan in the system is on the left side, but shows up as
RigthFan. Wouldn't it be better to simply number the fans and let the
"real" labeling be done via sensors.conf ?

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
