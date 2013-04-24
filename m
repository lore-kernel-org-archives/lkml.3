Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157Ab3DXJBL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 05:01:11 -0400
Received: from mga03.intel.com ([143.182.124.21]:46890 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758039Ab3DXJBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 05:01:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,540,1363158000"; 
   d="scan'208";a="290896595"
Message-ID: <1366794193.21369.11.camel@sauron.fi.intel.com>
Subject: Re: eGalax touchscreen regression
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Hui Wang <jason77.wang@gmail.com>,
        Zhang Jiejing <jiejing.zhang@freescale.com>,
        linux-input@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hofemeier, Ulf" <ulf.hofemeier@intel.com>
Date: Wed, 24 Apr 2013 12:03:13 +0300
In-Reply-To: <20130423154007.GB4104@core.coreip.homeip.net>
References: <1366708088.9823.16.camel@sauron.fi.intel.com>
	 <20130423154007.GB4104@core.coreip.homeip.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-23 at 08:40 -0700, Dmitry Torokhov wrote:
> > the eGalax driver now requires OF. For us this is a regression because
> > we do not have OF: https://bugs.tizen.org/jira/browse/TIVI-740
> 
> I see. In this case we need to come up with a platform data to pass
> wakeup gpio in case platform does not support OF. irq_to_gpio() is not
> supported on many platforms, causing compilation errors.
> 
> Is the platform that you are trying to use the touchscreen upstream?

OK, so this is about just a monitor with a touchscreen (Giantec high-res
capacitive 11.6” LCD monitor). The touchscreen is connected to a
commodity hardware via USB.

So yes, the platform _is_ upstream :-) Namely, we use just a SandyBridge
PC.

-- 
Best Regards,
Artem Bityutskiy

