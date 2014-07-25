Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760388AbaGYVqg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 17:46:36 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:33220 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbaGYVqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 17:46:35 -0400
Date: Fri, 25 Jul 2014 22:45:14 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org,
        Kweh Hock Leong <hock.leong.kweh@intel.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Chew Chiau Ee <chiau.ee.chew@intel.com>,
        Darren Hart <dvhart@linux.intel.com>, chiauee85@gmail.com,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org
Subject: Re: [PATCH] spi/pxa2xx-pci: Enable DMA binding through device name
Message-ID: <20140725224514.10f13885@alan.etchedpixels.co.uk>
In-Reply-To: <5237362.DJsH7MtqlU@wuerfel>
References: <1406196111-22861-1-git-send-email-hock.leong.kweh@intel.com>
	<5426556.OzZIXLrofJ@wuerfel>
	<1406285147.8530.13.camel@smile.fi.intel.com>
	<5237362.DJsH7MtqlU@wuerfel>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The current plan I think is to convert all platforms to use DT
> or ACPI so they get the right data from tables passed by the
> platform. I'm a bit puzzled about why Intel wants to support the
> non-ACPI non-DT case again. If we have to support this case anyway,
> what good will ACPI do us on those platforms?

Because some industries move very very slowly so still don't believe in
requiring ACPI or ACPI capable operating systems.

Alan
