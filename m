Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbaGQB3L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 21:29:11 -0400
Received: from mga03.intel.com ([143.182.124.21]:48582 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348AbaGQB3J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 21:29:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,674,1400050800"; 
   d="scan'208";a="457926272"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: Mark Brown <broonie@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: RE: [PATCH v3 7/7] ACPI: Cleanup useless ACPI inclusion.
Thread-Topic: [PATCH v3 7/7] ACPI: Cleanup useless ACPI inclusion.
Thread-Index: AQHPoNS4Owl88UV5j0iqd+oxRhZTzJuiFVoAgAChmwD///y8gIAAx1VA
Date: Thu, 17 Jul 2014 01:29:04 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E8802643042@SHSMSX101.ccr.corp.intel.com>
References: <cover.1387336613.git.lv.zheng@intel.com>
 <7ac00c9c5a32f7a3ec98f061080ba1573ae57d0d.1405500886.git.lv.zheng@intel.com>
 <20140716120750.GM17528@sirena.org.uk> <4307509.CpjlMkz69H@vostro.rjw.lan>
 <20140716213433.GD17528@sirena.org.uk>
In-Reply-To: <20140716213433.GD17528@sirena.org.uk>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> From: Mark Brown [mailto:broonie@kernel.org]
> Sent: Thursday, July 17, 2014 5:35 AM
> 
> On Wed, Jul 16, 2014 at 11:46:14PM +0200, Rafael J. Wysocki wrote:
> > On Wednesday, July 16, 2014 01:07:50 PM Mark Brown wrote:
> > > On Wed, Jul 16, 2014 at 04:59:02PM +0800, Lv Zheng wrote:
> 
> > > > The sst-haswell-dsp.c is an ACPI independent file, this patch removes
> > > > ACPI header files for it.
> 
> > > Applied, thanks.  Please use subject lines matching the style for the
> > > subsystem and send at least the cover letter for the series to everyone
> > > so that they know what's going on with dependencies and so on.
> 
> > Lv thought that this would go through the ACPI tree I suppose.
> 
> Even so the subject line should still line up (it's part of how some of
> us pick out which mail to read).

I just didn't notice this. :-)
I'll take care next time.

Thanks and best regards
-Lv
