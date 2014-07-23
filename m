Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426AbaGWDyJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 23:54:09 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:42040 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755865AbaGWDyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 23:54:07 -0400
Message-ID: <53CF319C.4070605@linaro.org>
Date: Wed, 23 Jul 2014 11:53:00 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
CC: Lv Zheng <zetalog@gmail.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v3 6/7] ACPI: Add support to force header inclusion rules
 for <acpi/acpi.h>.
References: <cover.1387336613.git.lv.zheng@intel.com> <cover.1405500886.git.lv.zheng@intel.com> <83e64d3b252019ce4b13fa46244a5c9a63bfc69f.1405500886.git.lv.zheng@intel.com>
In-Reply-To: <83e64d3b252019ce4b13fa46244a5c9a63bfc69f.1405500886.git.lv.zheng@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lv,

On 2014-7-16 16:58, Lv Zheng wrote:
> As there is only CONFIG_ACPI=n processing in the <linux/acpi.h>, it is not
> safe to include <acpi/acpi.h> directly for source out of Linux ACPI
> subsystems.
> 
> This patch adds error messaging to warn developers of such wrong
> inclusions.

Thanks for doing this, it makes life much easier for people who want to
use ACPI but not so familiar with ACPI.

Best Regards
Hanjun

