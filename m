Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478AbaEYP3B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 11:29:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946AbaEYP3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 11:29:00 -0400
Date: Sun, 25 May 2014 12:28:48 -0300
From: Flavio Leitner <fbl@redhat.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] i8k: increase fan limit to 3
Message-ID: <20140525152848.GK2498@t520.home>
References: <1400725168-21358-1-git-send-email-fbl@redhat.com>
 <20140522151048.GB1001@roeck-us.net>
 <20140522155458.GI12759@t520.home>
 <20140522180023.GB14814@roeck-us.net>
 <20140523170904.GA2498@t520.home>
 <537F9467.4020407@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537F9467.4020407@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 11:33:11AM -0700, Guenter Roeck wrote:
> On 05/23/2014 10:09 AM, Flavio Leitner wrote:
> >On Thu, May 22, 2014 at 11:00:23AM -0700, Guenter Roeck wrote:
> >>On Thu, May 22, 2014 at 12:54:58PM -0300, Flavio Leitner wrote:
> >>>On Thu, May 22, 2014 at 08:10:48AM -0700, Guenter Roeck wrote:
> >>>>On Wed, May 21, 2014 at 11:19:28PM -0300, Flavio Leitner wrote:
> >>>>>From: Flavio Leitner <fbl@sysclose.org>
> >>>I volunteer to test on precision 490n and on latitude D520.
> >>>
> >>Can you send me dmi information for those systems ?
> >>The output of "grep . /sys/class/dmi/id/*" should do.
> >
> 
> >/sys/class/dmi/id/chassis_vendor:Dell Inc.
> >/sys/class/dmi/id/product_name:Latitude D520
> 
> What is the maximum speed value for the D520 ?

D520, with no factor change:

   i8kfan     i8kctl
*  -   0      1.0 A02 JYCM0C1 31 -1 0 27660 0 0 -1
   -   0      1.0 A02 JYCM0C1 28 -1 0 27660 0 0 -1
   -   1      1.0 A02 JYCM0C1 29 -1 1 27660 97050 0 -1
   -   2      1.0 A02 JYCM0C1 28 -1 2 27660 153660 0 -1
   -   3      1.0 A02 JYCM0C1 28 -1 2 27660 155280 0 -1
   0   -      1.0 A02 JYCM0C1 28 -1 0 27660 0 0 -1
   1   -      1.0 A02 JYCM0C1 28 -1 0 27660 0 0 -1
   2   -      1.0 A02 JYCM0C1 29 -1 0 27660 0 0 -1
   3   -      1.0 A02 JYCM0C1 29 -1 0 27660 0 0 -1

[*] default after boot.

The level 3 doesn't change anything.  Actually i8kfan
reports -1 then.

fbl

