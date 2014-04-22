Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203AbaDVLNu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 07:13:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:33574 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755567AbaDVLNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 07:13:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,903,1389772800"; 
   d="scan'208";a="525295626"
Date: Tue, 22 Apr 2014 14:21:21 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: wsa@the-dreams.de, rjw@rjwysocki.net, awilliam@redhat.com, lenb@kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Lv Zheng <lv.zheng@intel.com>
Subject: Re: [Resend Patch 1/9] ACPICA: Executer: Fix buffer allocation issue
 for generic_serial_bus region field accesses.
Message-ID: <20140422112121.GE30677@intel.com>
References: <1397654682-7094-1-git-send-email-tianyu.lan@intel.com>
 <1398147855-9868-1-git-send-email-tianyu.lan@intel.com>
 <1398147855-9868-2-git-send-email-tianyu.lan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398147855-9868-2-git-send-email-tianyu.lan@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 02:24:07PM +0800, Lan Tianyu wrote:
> From: Lv Zheng <lv.zheng@intel.com>
> 
> The size of the buffer allocated for generic_serial_bus region access
> is not correct.  This patch introduces acpi_ex_get_serial_access_length()
> to be invoked to obtain correct data buffer length.  Reported by
> Lan Tianyu, Fixed by Lv Zheng.
> 
> Signed-off-by: Lv Zheng <lv.zheng@intel.com>
> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
