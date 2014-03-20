Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbaCTF5z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 01:57:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:12371 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755088AbaCTF5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 01:57:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,692,1389772800"; 
   d="scan'208";a="495607259"
Message-ID: <1395295065.3571.10.camel@rzhang1-mobl4>
Subject: Re: [PATCH v2 3/5] thermal: dove: prepare new Dove DT Kconfig
 variable
From: Zhang Rui <rui.zhang@intel.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Date: Thu, 20 Mar 2014 13:57:45 +0800
In-Reply-To: <20140304040318.GG1872@titan.lakedaemon.net>
References: <1393536486-3827-3-git-send-email-sebastian.hesselbarth@gmail.com>
	 <1393662801-17950-3-git-send-email-sebastian.hesselbarth@gmail.com>
	 <20140304040318.GG1872@titan.lakedaemon.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-03 at 23:03 -0500, Jason Cooper wrote:
> On Sat, Mar 01, 2014 at 09:33:19AM +0100, Sebastian Hesselbarth wrote:
> > DT-enabled Dove will move over from ARCH_DOVE in mach-dove to MACH_DOVE in
> > mach-mvebu. As non-DT ARCH_DOVE will stay to rot for a while, add a new
> > DT-only MACH_DOVE Kconfig.
> > 
> > Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> > ---
> > Rui, Eduardo,
> > 
> > Mark Brown requested to take the corresponding ASoC patch through
> > his tree. Therefore, I have split the former patch into individual subsystem
> > patches.              
> > 
> > Cc: Zhang Rui <rui.zhang@intel.com>
> > Cc: Eduardo Valentin <eduardo.valentin@ti.com>
> > Cc: Jason Cooper <jason@lakedaemon.net>
> > Cc: Andrew Lunn <andrew@lunn.ch>
> > Cc: Gregory Clement <gregory.clement@free-electrons.com>
> > Cc: linux-pm@vger.kernel.org
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: linux-kernel@vger.kernel.org
> > ---
> >  drivers/thermal/Kconfig | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Acked-by: Jason Cooper <jason@lakedaemon.net>

applied.

thanks,
rui
> 
> thx,
> 
> Jason.


