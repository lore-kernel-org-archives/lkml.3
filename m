Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164Ab3BSNC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 08:02:26 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:40757 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756853Ab3BSNCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 08:02:24 -0500
X-IronPort-AV: E=Sophos;i="4.84,695,1355068800"; 
   d="scan'208";a="6730208"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: akpm@linux-foundation.org, jiang.liu@huawei.com, wujianguo@huawei.com,
        hpa@zytor.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        linfeng@cn.fujitsu.com, yinghai@kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, rob@landley.net,
        kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, mgorman@suse.de,
        rientjes@google.com, guz.fnst@cn.fujitsu.com, rusty@rustcorp.com.au,
        lliubbo@gmail.com, jaegeuk.hanse@gmail.com, tony.luck@intel.com,
        glommer@parallels.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [Bug fix PATCH 0/2] Bug fix for movablemem_map boot option.
Date: Tue, 19 Feb 2013 21:01:42 +0800
Message-Id: <1361278904-8690-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/19 21:01:42,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/19 21:01:43,
	Serialize complete at 2013/02/19 21:01:43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two bug fix patches for movablemem_map boot option.

root (2):
  acpi, movablemem_map: Do not zero numa_meminfo in numa_init().
  acpi, movablemem_map: Set numa_nodes_hotplug nodemask when using SRAT
    info.

 arch/x86/mm/numa.c |    6 ++++--
 arch/x86/mm/srat.c |    6 ++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

