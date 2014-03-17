Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932549AbaCQJhD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 05:37:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:62319 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932485AbaCQJhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 05:37:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,668,1389772800"; 
   d="scan'208";a="493476302"
Date: Mon, 17 Mar 2014 11:44:34 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alexandre Courbot <gnurou@gmail.com>,
        Lan Tianyu <tianyu.lan@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        Alan Cox <alan.cox@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 5/5] gpio / ACPI: Add support for ACPI GPIO operation
 regions
Message-ID: <20140317094434.GA19349@intel.com>
References: <1394456094-21671-6-git-send-email-mika.westerberg@linux.intel.com>
 <1394812687-12715-1-git-send-email-mika.westerberg@linux.intel.com>
 <CACRpkdYyBgL0W5cYpAEQZzc7u5K4yEBOr5hD5gDFFPBYvxkgqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYyBgL0W5cYpAEQZzc7u5K4yEBOr5hD5gDFFPBYvxkgqQ@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 05:25:39PM +0100, Linus Walleij wrote:
> On Fri, Mar 14, 2014 at 4:58 PM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> 
> > GPIO operation regions is a new feature introduced in ACPI 5.0
> > specification. This feature adds a way for platform ASL code to call back
> > to OS GPIO driver and toggle GPIO pins.
> 
> OK this version of the patch applied!

Thanks!
