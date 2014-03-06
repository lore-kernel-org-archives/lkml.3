Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751015AbaCFG4u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 01:56:50 -0500
Received: from mga09.intel.com ([134.134.136.24]:25225 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbaCFG4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 01:56:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,598,1389772800"; 
   d="scan'208";a="467538417"
User-Agent: Microsoft-MacOutlook/14.3.9.131030
Date: Wed, 05 Mar 2014 22:56:54 -0800
Subject: Re: [PATCH] pinctrl-baytrail: add function mux checking in gpio pin
 request
From: Darren Hart <dvhart@linux.intel.com>
To: Chew Chiau Ee <chiau.ee.chew@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: Mathias Nyman <mathias.nyman@linux.intel.com>,
        <linux-kernel@vger.kernel.org>
Message-ID: <CF3D5ADF.74A62%dvhart@linux.intel.com>
Thread-Topic: [PATCH] pinctrl-baytrail: add function mux checking in gpio pin
 request
References: <1394114389-27106-1-git-send-email-chiau.ee.chew@intel.com>
In-Reply-To: <1394114389-27106-1-git-send-email-chiau.ee.chew@intel.com>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/6/14, 5:59, "Chew Chiau Ee" <chiau.ee.chew@intel.com> wrote:

>From: Chew, Kean Ho <kean.ho.chew@intel.com>
>
>The requested gpio pin must has the func_pin_mux field set
>to GPIO function by BIOS/FW in advanced. Else, the gpio pin
>request would fail. This is to ensure that we do not expose
>any gpio pins which shall be used for alternate functions,
>for eg: wakeup pin, I/O interfaces for LPSS, etc.
>
>Signed-off-by: Chew, Kean Ho <kean.ho.chew@intel.com>
>Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>

Thanks for sending this out Chiau Ee,

Reviewed-by: Darren Hart <dvhart@linux.intel.com>

-- 
Darren Hart
Yocto Project - Linux Kernel
Intel Open Source Technology Center




