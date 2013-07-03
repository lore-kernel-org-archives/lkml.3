Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311Ab3GCSgC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:36:02 -0400
Received: from mga14.intel.com ([143.182.124.37]:36387 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755366Ab3GCSf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:35:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,989,1363158000"; 
   d="scan'208";a="360086647"
Date: Wed, 3 Jul 2013 21:41:23 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>, john.ronciak@intel.com,
        miles.j.penner@intel.com, bruce.w.allan@intel.com,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v2 0/8] Thunderbolt workarounds
Message-ID: <20130703184123.GC4898@intel.com>
References: <1372860295-8306-1-git-send-email-mika.westerberg@linux.intel.com>
 <20130703182900.GA29079@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130703182900.GA29079@srcf.ucam.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 07:29:00PM +0100, Matthew Garrett wrote:
> Are there any plans to provide native support for the Thunderbolt 
> controller, rather than relying on system management mode?

I believe there are some to implement a native Thunderbolt controller
driver but I don't know the details. 

Bruce Allan and Miles Penner (who are CC'd here) might have a better answer
for you.
