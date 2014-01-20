Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbaATLOY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 06:14:24 -0500
Received: from mga02.intel.com ([134.134.136.20]:42978 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917AbaATLOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 06:14:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,689,1384329600"; 
   d="scan'208";a="441615261"
Date: Mon, 20 Jan 2014 13:21:22 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Chew Chiau Ee <chiau.ee.chew@intel.com>
Cc: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI / LPSS: Add BYT ACPI mode PWM
Message-ID: <20140120112122.GF18029@intel.com>
References: <1390245122-18907-1-git-send-email-chiau.ee.chew@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390245122-18907-1-git-send-email-chiau.ee.chew@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 03:12:02AM +0800, Chew Chiau Ee wrote:
> From: Chew, Chiau Ee <chiau.ee.chew@intel.com>
> 
> Intel BayTrail LPSS consists of two PWM controllers which can
> be enumerated from ACPI namespace.
> 
> Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
