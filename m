Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab3KDRjb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 12:39:31 -0500
Received: from mga09.intel.com ([134.134.136.24]:59062 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753298Ab3KDRja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 12:39:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,633,1378882800"; 
   d="scan'208";a="422097651"
Date: Mon, 4 Nov 2013 18:39:27 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: James Ralston <james.d.ralston@intel.com>
Cc: Peter Tyser <ptyser@xes-inc.com>, linux-kernel@vger.kernel.org,
        Seth Heasley <seth.heasley@intel.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 4/4] lpc_ich: Add Device IDs for Intel Wildcat Point-LP
 PCH
Message-ID: <20131104173927.GG6566@zurbaran>
References: <1383586280-4765-1-git-send-email-james.d.ralston@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383586280-4765-1-git-send-email-james.d.ralston@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

On Mon, Nov 04, 2013 at 09:31:20AM -0800, James Ralston wrote:
> This patch adds the TCO Watchdog Device IDs for the Intel Wildcat Point-LP PCH.
> 
> Signed-off-by: James Ralston <james.d.ralston@intel.com>
> ---
>  drivers/mfd/lpc_ich.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
Applied, right on time for 3.13.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
