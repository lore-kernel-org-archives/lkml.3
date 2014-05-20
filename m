Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090AbaETIax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 04:30:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:24703 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512AbaETIav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 04:30:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,872,1392192000"; 
   d="scan'208";a="534709546"
Date: Tue, 20 May 2014 11:30:46 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
Cc: linus.walleij@linaro.org, gnurou@gmail.com, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, bin.yang@intel.com
Subject: Re: [PATCH] gpio: Add support for Intel SoC PMIC (Crystal Cove)
Message-ID: <20140520083046.GD1651@lahna.fi.intel.com>
References: <1400082247-24168-1-git-send-email-lejun.zhu@linux.intel.com>
 <20140519103933.GK2067@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140519103933.GK2067@lahna.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 01:39:33PM +0300, Mika Westerberg wrote:
> On Wed, May 14, 2014 at 11:44:07PM +0800, Zhu, Lejun wrote:
> > Devices based on Intel SoC products such as Baytrail have a Power
> > Management IC. In the PMIC there are subsystems for voltage regulation,
> > A/D conversion, GPIO and PWMs. The PMIC in Baytrail-T platform is called
> > Crystal Cove.
> > 
> > This patch adds support for the GPIO function in Crystal Cove.
> 
> I have few comments as well in addition to comments from Linus and
> Alexandre.

One more thing, I just remembered. The crystal cove GPIO driver is
supposed to provide ACPI Operation Regions to the ASL code so you need
to make sure you have ACPI handle associated with the device before you
register your driver to the GPIO core.
