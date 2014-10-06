Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038AbaJFR2y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 13:28:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:50627 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbaJFR2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 13:28:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,664,1406617200"; 
   d="scan'208";a="584246682"
Date: Mon, 6 Oct 2014 10:17:19 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Jonathan Cameron <jic23@kernel.org>, IIO <linux-iio@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        DEVICE TREE <devicetree@vger.kernel.org>,
        Carlo Caione <carlo@caione.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Alan Cox <alan@linux.intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Hartmut Knaack <knaack.h@gmx.de>, Fugang Duan <B38611@freescale.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>,
        Sebastian Reichel <sre@debian.org>,
        Johannes Thumshirn <johannes.thumshirn@men.de>,
        Philippe Reynes <tremyfr@yahoo.fr>,
        Angelo Compagnucci <angelo.compagnucci@gmail.com>,
        Doug Anderson <dianders@chromium.org>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH v6 1/2] mfd/axp20x: extend axp20x to support axp288 pmic
Message-ID: <20141006101719.7efb62e8@icelake>
In-Reply-To: <20141006165209.GC3848@lee--X1>
References: <1411644045-21281-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<54268DC0.40406@kernel.org>
	<20141006165209.GC3848@lee--X1>
Organization: OTC
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Oct 2014 17:52:09 +0100
Lee Jones <lee.jones@linaro.org> wrote:

> Date: Mon, 6 Oct 2014 17:52:09 +0100
> User-Agent: Mutt/1.5.21 (2010-09-15)
> 
> On Sat, 27 Sep 2014, Jonathan Cameron wrote:
> 
> > On 25/09/14 12:20, Jacob Pan wrote:  
> > > X-Powers AXP288 is a customized PMIC for Intel Baytrail-CR
> > > platforms. Similar to AXP202/209, AXP288 comes with USB charger,
> > > more LDO and BUCK channels, and AD converters. It also provides
> > > extended status and interrupt reporting capabilities than the
> > > devices currently supported in axp20x.c.
> > >
> > > In addition to feature extension, this patch also adds ACPI
> > > binding for enumeration.
> > >
> > > This consolidated driver should support more X-Powers' PMICs in
> > > both device tree and ACPI enumerated platforms.
> > >
> > > Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > > Reviewed-by: Maxime Ripard <maxime.ripard@free-electrons.com>  
> > Reviewed-by: Jonathan Cameron <jic23@kernel.org>
> > 
> > (I'm assuming Lee will take the whole series when he is happy with
> > it).  
> 
> I only see patch 1?
Hi Lee,
here is #2. will also send you a copy directly.

https://lkml.org/lkml/2014/9/25/538
