Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751117AbaEWB0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 21:26:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:11349 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872AbaEWB0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 21:26:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,890,1392192000"; 
   d="scan'208";a="543672101"
Message-ID: <537EA3B7.2080307@linux.intel.com>
Date: Fri, 23 May 2014 09:26:15 +0800
From: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: linus.walleij@linaro.org, gnurou@gmail.com, mathias.nyman@linux.intel.com,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        jacob.jun.pan@linux.intel.com, bin.yang@intel.com
Subject: Re: [PATCH v3] gpio: Add support for Intel SoC PMIC (Crystal Cove)
References: <1400734743-3154-1-git-send-email-lejun.zhu@linux.intel.com> <20140522111554.GG1651@lahna.fi.intel.com>
In-Reply-To: <20140522111554.GG1651@lahna.fi.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 5/22/2014 7:15 PM, Mika Westerberg wrote:
> I suppose this is dependent on the MFD driver right? If so, this should
> probably be merged along with that patch.
> 

The MFD driver has been submitted on LKML as well. I think these two
drivers can be pulled into corresponding trees, and meet each other in
the Linus tree in the end, right?

Best Regards
Lejun
