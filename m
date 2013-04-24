Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164Ab3DXXkj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 19:40:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:24791 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758268Ab3DXXkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 19:40:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,546,1363158000"; 
   d="scan'208";a="291505521"
Message-ID: <1366846832.2102.1.camel@rzhang1-mobl4>
Subject: Re: [PATCH 28/30] MAINTAINERS: update thermal entry by adding file
 cpu_cooling.h
From: Zhang Rui <rui.zhang@intel.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: amit.kachhap@linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 25 Apr 2013 07:40:32 +0800
In-Reply-To: <5178178E.5090605@ti.com>
References: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com>
	 <1366218743-20841-29-git-send-email-eduardo.valentin@ti.com>
	 <5178178E.5090605@ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-24 at 13:34 -0400, Eduardo Valentin wrote:
> Rui,
> 
> On 17-04-2013 13:12, Eduardo Valentin wrote:
> > Add cpu_cooling.h to thermal entry in MAINTAINERS.
> >
> > Cc: Zhang Rui <rui.zhang@intel.com>
> > Cc: linux-pm@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
> > ---
> >   MAINTAINERS | 1 +
> >   1 file changed, 1 insertion(+)
> >
> 
> This one didnt get in. Does it need to go in a different tree?
> 
I have a separate branch which contains all the three patches that
changes MAINTAINERS file.
I'm not sure if I should take them or not at the moment.

thanks,
rui
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 05dd187..3e075dc 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -8011,6 +8011,7 @@ T:      git git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git
> >   S:      Supported
> >   F:      drivers/thermal/
> >   F:      include/linux/thermal.h
> > +F:      include/linux/cpu_cooling.h
> >
> >   THINGM BLINK(1) USB RGB LED DRIVER
> >   M:	Vivien Didelot <vivien.didelot@savoirfairelinux.com>
> >
> 


