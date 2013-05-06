Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab3EFHAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 03:00:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:58643 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111Ab3EFHAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 03:00:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,619,1363158000"; 
   d="scan'208";a="308781377"
Date: Mon, 6 May 2013 10:04:29 +0300
From: "'Mika Westerberg'" <mika.westerberg@linux.intel.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Samuel Ortiz'" <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] mfd: intel_msic: remove unnecessary
 platform_set_drvdata()
Message-ID: <20130506070429.GA29823@intel.com>
References: <002e01ce4a0e$cbe76460$63b62d20$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <002e01ce4a0e$cbe76460$63b62d20$@samsung.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 01:04:25PM +0900, Jingoo Han wrote:
> The driver core clears the driver data to NULL after device_release
> or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
> (device-core: Ensure drvdata = NULL when no driver is bound).
> Thus, it is not needed to manually clear the device driver data to NULL.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
