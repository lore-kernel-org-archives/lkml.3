Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab3IMUBu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 16:01:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:9255 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754415Ab3IMUBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 16:01:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,900,1371106800"; 
   d="scan'208";a="403045276"
Date: Fri, 13 Sep 2013 23:07:16 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH] x86: add pin control support to Intel low power subsystem
Message-ID: <20130913200716.GH7393@intel.com>
References: <1379080949-21734-1-git-send-email-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379080949-21734-1-git-send-email-mathias.nyman@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 05:02:29PM +0300, Mathias Nyman wrote:
> x86 chips with LPSS (low power subsystem) such as Lynxpoint and
> Baytrail have SoC like peripheral support and controllable pins.
> 
> At the moment, Baytrail needs the pinctrl-baytrail driver to let
> peripherals control their gpio resources, but more pincontrol functions
> such as pin muxing and grouping are possible to add later.
> 
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>

Makes sense, and since there seems to be no way to enable pinctrl by
just selecting it from 'make XXXconfig',

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
