Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab3DXGEp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 02:04:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:62110 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924Ab3DXGEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 02:04:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,540,1363158000"; 
   d="scan'208";a="300234225"
Message-ID: <1366783612.21369.5.camel@sauron.fi.intel.com>
Subject: Re: eGalax touchscreen regression
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Hui Wang <jason77.wang@gmail.com>,
        Zhang Jiejing <jiejing.zhang@freescale.com>,
        linux-input@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hofemeier, Ulf" <ulf.hofemeier@intel.com>
Date: Wed, 24 Apr 2013 09:06:52 +0300
In-Reply-To: <20130423154007.GB4104@core.coreip.homeip.net>
References: <1366708088.9823.16.camel@sauron.fi.intel.com>
	 <20130423154007.GB4104@core.coreip.homeip.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
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

Unfortunately I do not really know about it, but once I learn, I'll come
back. Thanks!

-- 
Best Regards,
Artem Bityutskiy

