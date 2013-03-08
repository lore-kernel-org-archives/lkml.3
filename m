Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab3CHFwq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 00:52:46 -0500
Received: from mga02.intel.com ([134.134.136.20]:3219 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744Ab3CHFwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 00:52:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,806,1355126400"; 
   d="scan'208";a="273792646"
Subject: [PATCH 0/3] intel_idle: set the state_tables array into __initdata
 to save mem
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: lenb@kernel.org, daniel.lezcano@linaro.org, len.brown@intel.com
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com
In-Reply-To: <1362674529.31506.17.camel@cliu38-desktop-build>
References: <1362674529.31506.17.camel@cliu38-desktop-build>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Mar 2013 23:02:06 +0800
Message-ID: <1362754926.31506.42.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Daniel suggested, I did some cleanup before setting the state_tables array
into __initdata.

Thanks your help to review them.

[PATCH 1/3] intel_idle: changing the continue to break in intel_idle_cpu_init()
[PATCH 2/3] intel_idle: Removing the redundant calculating for dev->state_count
[PATCH 3/3] intel_idle: set the state_tables array as __initdata to save mem


