Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745AbaEVMdW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 08:33:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754614AbaEVMdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 08:33:20 -0400
Date: Thu, 22 May 2014 09:33:12 -0300
From: Flavio Leitner <fbl@redhat.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Flavio Leitner <fbl@sysclose.org>
Subject: Re: [PATCH] i8k: increase fan limit to 3
Message-ID: <20140522123252.GF12759@t520.home>
References: <1400725168-21358-1-git-send-email-fbl@redhat.com>
 <537D6FC8.5000105@roeck-us.net>
 <20140522034530.GD12759@t520.home>
 <537D8CED.4000603@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537D8CED.4000603@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 10:36:45PM -0700, Guenter Roeck wrote:
> On 05/21/2014 08:45 PM, Flavio Leitner wrote:
> >On Wed, May 21, 2014 at 08:32:24PM -0700, Guenter Roeck wrote:
> >>On 05/21/2014 07:19 PM, Flavio Leitner wrote:
> >>>From: Flavio Leitner <fbl@sysclose.org>
> >>>
> >>>It is possible to increase left fan speed on a
> >>>DELL Precision 490n system up to 3.
> >>>
> >>>     value    fan rpm
> >>>       1      35460
> >>>       2      64740
> >>>       3      78510
> >>>
> >>Guess the speed factor 30 doesn't apply here.
> >
> >Those are actual rpms, not just a multiplied rpm. What I mean
> >is that you can hear the fan spinning up or down and the
> >temperature going up or down accordingly.
> >
> I don't think there are any fans running at 78k rpm. The real speed
> is 78,510 / 30 or 2,617 rpm. You should set the fan_mult module
> parameter to 1 for your system.

Sure. I will do that. I didn't want to change anything else besides
the speed level and that is what sensors reports by default.

> >But even setting it to 3 is not enough to spin at maximum
> >speed. Anyway, now I can load the system without the FBDIMM
> >going above 75oC.
> >
> Did you try to set higher values ?

Up to 4 which did nothing that I could notice.
No difference regarding to noise or temp or rpm.

fbl
