Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933365AbaCRW7D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 18:59:03 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:43441 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932595AbaCRW7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 18:59:01 -0400
Date: Tue, 18 Mar 2014 23:58:42 +0100
From: Sabrina Dubroca <sd@queasysnail.net>
To: "Zheng, Lv" <lv.zheng@intel.com>
Cc: Valdis Kletnieks <validis.kletnieks@vt.edu>, Lv Zheng <zetalog@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Moore, Robert" <robert.moore@intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>
Subject: Re: [RFC PATCH 1/2] ACPICA: Dispatcher: Ignore SyncLevel for
 auto-serialization mechanism.
Message-ID: <20140318225842.GA25669@kria>
References: <14866.1394813101@turing-police.cc.vt.edu>
 <cover.1395028738.git.lv.zheng@intel.com>
 <bf7078d77da8d24ff11337673c6f0ea9442f294a.1395028738.git.lv.zheng@intel.com>
 <1AE640813FDE7649BE1B193DEA596E88024E1B17@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E88024E1B17@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2014-03-18, 00:50:04 +0000, Zheng, Lv wrote:
> Hi, Sabrina and Valdis
> 
> Could you give this patch a try to see if this patch is working?
> 
> Thanks and best regards
> -Lv

I applied the two patches. The laptop boots and there is no ACPI
error in the logs, both with auto-serialization enabled and disabled.

Thanks,

-- 
Sabrina
