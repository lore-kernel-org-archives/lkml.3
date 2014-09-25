Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbaIYRwj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 13:52:39 -0400
Received: from mga14.intel.com ([192.55.52.115]:22034 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753486AbaIYRwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 13:52:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="391625839"
Date: Thu, 25 Sep 2014 10:52:34 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: IIO <linux-iio@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DEVICE TREE <devicetree@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>, Carlo Caione <carlo@caione.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Alan Cox <alan@linux.intel.com>,
        Jean Delvare <khali@linux-fr.org>,
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
        Rafael Wysocki <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH v5 1/2] mfd/axp20x: extend axp20x to support axp288 pmic
Message-ID: <20140925105234.65c826c9@jacob-VirtualBox>
In-Reply-To: <20140925100220.GA15315@lukather>
References: <1411518027-19907-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<1411518027-19907-2-git-send-email-jacob.jun.pan@linux.intel.com>
	<20140925100220.GA15315@lukather>
Organization: OTC
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2014 12:02:20 +0200
Maxime Ripard <maxime.ripard@free-electrons.com> wrote:

> It's fine otherwise. Once fixed, you can add my
> 
> Reviewed-by: Maxime Ripard <maxime.ripard@free-electrons.com>
thanks for the review. will fix as suggested except rewriting flow in
axp20x_match_device() as suggested by Lee Jones.
