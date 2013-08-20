Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426Ab3HTOsX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 10:48:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:18386 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193Ab3HTOsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 10:48:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,921,1367996400"; 
   d="scan'208";a="389157303"
Message-ID: <521381A9.4020501@intel.com>
Date: Tue, 20 Aug 2013 07:48:09 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Libin <huawei.libin@huawei.com>
CC: Vegard Nossum <vegardno@ifi.uio.no>, Pekka Enberg <penberg@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, guohanjun@huawei.com,
        zhangdianfang@huawei.com
Subject: Re: [BUG REPORT]kernel panic with kmemcheck config
References: <5212D7F2.3020308@huawei.com>
In-Reply-To: <5212D7F2.3020308@huawei.com>
Content-Type: text/plain; charset=gb18030
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2013 07:44 PM, Libin wrote:
> When kmemcheck kernel support configured£¬we encountered random kernel panic
> (sometimes can be booted) during system boot process in our environment. I
> have tested the mainline kernel version from v3.0 to v3.11-rc6, they also
> have this problem. And the memory limit within 4G also tested.

Could you provide a more complete oops?  Doing it properly usually
requires either a remote console of some kind (netconsole, serial, usb
debug, etc...).
