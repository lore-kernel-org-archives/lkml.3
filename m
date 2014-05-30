Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168AbaE3Idb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 04:33:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:2927 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753792AbaE3Id3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 04:33:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,939,1392192000"; 
   d="scan'208";a="539940117"
Date: Fri, 30 May 2014 11:33:25 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, matthew.garrett@nebula.com
Subject: Re: [PATCH 0/10] ACPI enumeration rework (was: Re: [PATCH V7 00/11]
 ACPI: ACPI enumeration rework)
Message-ID: <20140530083325.GB1645@lahna.fi.intel.com>
References: <1400781753-2682-1-git-send-email-rui.zhang@intel.com>
 <35042328.kk6ZUUdfyN@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35042328.kk6ZUUdfyN@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 04:20:41AM +0200, Rafael J. Wysocki wrote:
> On Friday, May 23, 2014 02:02:22 AM Zhang Rui wrote:
> > Hi, all,
> > 
> > Currently, PNP bus is used as the default bus for for enumerating ACPI
> > devices with _HID/_CID.
> > For a device that needs to be enumerated to platform bus, we need to add
> > its id string to the platform scan handler white list explicitly.
> > 
> > This becomes a problem as more and more _HID devices need to be
> > enumerated to platform bus nowadays, thus the list is continuously growing.
> > 
> > So, a solution that uses platform bus for _HID enumeration by default
> > is preferred.
> > 
> 
> OK, this has had several rounds of review already and we're really starting
> to run out of time with it, so my version of this patchset follows.
> 
> It is mostly based on your patches, but reordered and with some major
> changes.  Compiled only for now, so please let me know if there's any
> breakage in it.  [The last patch will not apply without update of the
> device list being removed, but generally this is on top of linux-next
> material.]

The series looks good to me now.

You can add

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>

to all the patches if you like.
