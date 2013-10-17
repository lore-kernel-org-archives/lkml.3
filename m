Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab3JQXSL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 19:18:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:29043 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783Ab3JQXSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 19:18:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,518,1378882800"; 
   d="scan'208";a="420884510"
Date: Thu, 17 Oct 2013 16:18:08 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Matt Fleming <matt@console-pimps.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Fleming, Matt" <matt.fleming@intel.com>
Subject: Re: [PATCH 5/5] efi: Capsule update support and pstore backend
Message-ID: <20131017231808.GK7456@tassilo.jf.intel.com>
References: <1381931460-6999-1-git-send-email-matt@console-pimps.org>
 <1381931460-6999-6-git-send-email-matt@console-pimps.org>
 <20131016141939.GA28684@srcf.ucam.org>
 <3908561D78D1C84285E8C5FCA982C28F31D31122@ORSMSX106.amr.corp.intel.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D443EF862E@USINDEM103.corp.hds.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D443EF862E@USINDEM103.corp.hds.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But, as Eric said, it should be OK if it is implemented in the kdump kenel.

kdump doesn't work for a lot of use cases (too much memory consumption)

-Andi
