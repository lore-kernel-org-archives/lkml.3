Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbaJBOiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 10:38:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:13719 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465AbaJBOiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 10:38:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,638,1406617200"; 
   d="scan'208";a="599835126"
Date: Thu, 2 Oct 2014 17:38:09 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, Aaron Lu <aaron.lu@intel.com>,
        Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH v3 04/15] ACPI: Document ACPI device specific properties
Message-ID: <20141002143809.GQ1786@lahna.fi.intel.com>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com>
 <15893883.nvuW3ndylz@wuerfel>
 <20141002133654.GP1786@lahna.fi.intel.com>
 <3986527.L7rDZAb4g5@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3986527.L7rDZAb4g5@wuerfel>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 04:29:03PM +0200, Arnd Bergmann wrote:
> Is this a limitation in the way that the AML syntax and compiler works,
> or is this a decision you made specifically for the _DSD syntax and that
> could still be changed if there is an overwhelming interest?

It is only limitation of the _DSD device property UUID specification and
our implementation. It can be changed if needed.
