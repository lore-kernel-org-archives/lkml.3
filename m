Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627Ab3KGTi7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 14:38:59 -0500
Received: from mga11.intel.com ([192.55.52.93]:17760 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311Ab3KGTiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 14:38:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,653,1378882800"; 
   d="scan'208";a="429624388"
Message-ID: <527BED2C.3050604@linux.intel.com>
Date: Thu, 07 Nov 2013 11:42:36 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH] intel_mid: do not re-introduce usage of obsolete __cpuinit
References: <1383849290-11250-1-git-send-email-paul.gortmaker@windriver.com>
In-Reply-To: <1383849290-11250-1-git-send-email-paul.gortmaker@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2013 10:34 AM, Paul Gortmaker wrote:
> The commit 712b6aa8731a7e148298c58cea66a5209c659e3c [Nov7 linux-next
> via tip/auto-latest] ("intel_mid: Renamed *mrst* to *intel_mid*")
> adds a __cpuinit.
>
> We removed this a couple versions ago; we now want to remove
> the compat no-op stubs.  Introducing new users is not what
> we want to see at this point in time, as it will break once
> the stubs are gone.
>
> Cc: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
> Cc: David Cohen <david.a.cohen@linux.intel.com>
> Cc: H. Peter Anvin <hpa@linux.intel.com>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Acked-by: David Cohen <david.a.cohen@linux.intel.com>
