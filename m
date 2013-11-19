Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094Ab3KSU6k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 15:58:40 -0500
Received: from mga14.intel.com ([143.182.124.37]:46388 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353Ab3KSU6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 15:58:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,731,1378882800"; 
   d="scan'208";a="430478434"
Date: Tue, 19 Nov 2013 23:05:13 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        "Moore, Robert" <robert.moore@intel.com>,
        Toshi Kani <toshi.kani@hp.com>, Yinghai Lu <yinghai@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Aaron Lu <aaron.lu@intel.com>, Lv Zheng <lv.zheng@intel.com>
Subject: Re: [PATCH 0/10] ACPI: Device objects for all namespace nodes and
 PCI root hotplug integration
Message-ID: <20131119210512.GS2281@intel.com>
References: <1421028.Rsfpmhnym3@vostro.rjw.lan>
 <20131119143046.GL2281@intel.com>
 <3736594.HRILCo6Ms2@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3736594.HRILCo6Ms2@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 09:51:19PM +0100, Rafael J. Wysocki wrote:
> On Tuesday, November 19, 2013 04:30:46 PM Mika Westerberg wrote:
> > On Sun, Nov 17, 2013 at 05:29:41PM +0100, Rafael J. Wysocki wrote:
> > > This is 3.14 material, but I'm posting it today to let you know it is coming.
> > > Of course, if you see any immediate problems with the following patches, please
> > > let me know.
> > 
> > For what it's worth, I have tested this series on three different systems
> > that have Thunderbolt and it still works fine after the series has been
> > applied :)
> 
> Awesome, thanks!
> 
> I hope you won't mind if I add your Tested-by to the series. :-)

Not at all,

Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
