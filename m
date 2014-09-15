Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759086AbaIOVIW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 17:08:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:31178 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756520AbaIOVIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 17:08:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,530,1406617200"; 
   d="scan'208";a="603223756"
Date: Mon, 15 Sep 2014 13:29:31 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Hartmut Knaack <knaack.h@gmx.de>
Cc: Jonathan Cameron <jic23@kernel.org>, IIO <linux-iio@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        DEVICE TREE <devicetree@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>, Carlo Caione <carlo@caione.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Alan Cox <alan@linux.intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Fugang Duan <B38611@freescale.com>, Arnd Bergmann <arnd@arndb.de>,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>,
        Sebastian Reichel <sre@debian.org>,
        Johannes Thumshirn <johannes.thumshirn@men.de>,
        Philippe Reynes <tremyfr@yahoo.fr>,
        Angelo Compagnucci <angelo.compagnucci@gmail.com>,
        Doug Anderson <dianders@chromium.org>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH v3 5/5] iio: add documentation for current attribute
Message-ID: <20140915132931.00dc6f04@ultegra>
In-Reply-To: <5415948C.6080509@gmx.de>
References: <1410477357-6407-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<1410477357-6407-6-git-send-email-jacob.jun.pan@linux.intel.com>
	<5414A138.9080602@kernel.org>
	<5415948C.6080509@gmx.de>
Organization: OTC
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Sep 2014 15:13:48 +0200
Hartmut Knaack <knaack.h@gmx.de> wrote:

> Where is the offset?
there is no offset. thanks for pointing this out.
