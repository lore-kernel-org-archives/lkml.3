Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933491AbaJ2Ooi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 10:44:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:34840 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932960AbaJ2Oog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 10:44:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,810,1406617200"; 
   d="scan'208";a="622805970"
Date: Wed, 29 Oct 2014 16:44:15 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Darren Hart <dvhart@linux.intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI / GPIO: Pass index to acpi_get_gpiod_by_index()
 when using properties
Message-ID: <20141029144415.GN1304@lahna.fi.intel.com>
References: <1414494927-204923-1-git-send-email-mika.westerberg@linux.intel.com>
 <20141029085429.GJ1304@lahna.fi.intel.com>
 <1738599.RytCx391OM@vostro.rjw.lan>
 <11524706.oiA2Jzq65k@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11524706.oiA2Jzq65k@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 03:51:59PM +0100, Rafael J. Wysocki wrote:
> Never mind.  I need to rebase the series anyway because of a bug in the
> second patch, so I'll fold the $subject one into patch [5/12].

Thank you.
