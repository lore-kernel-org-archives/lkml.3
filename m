Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072Ab3EPWRA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 18:17:00 -0400
Received: from mga14.intel.com ([143.182.124.37]:51185 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754991Ab3EPWQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 18:16:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,686,1363158000"; 
   d="scan'208";a="303637387"
Date: Fri, 17 May 2013 00:16:55 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: James Ralston <james.d.ralston@intel.com>
Cc: Peter Tyser <ptyser@xes-inc.com>, linux-kernel@vger.kernel.org,
        Seth Heasley <seth.heasley@intel.com>
Subject: Re: [PATCH v2] lpc_ich: Watchdog/GPIO patch for Intel Avoton SoC
Message-ID: <20130516221655.GT22822@zurbaran>
References: <1368128333-1765-1-git-send-email-james.d.ralston@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368128333-1765-1-git-send-email-james.d.ralston@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

On Thu, May 09, 2013 at 12:38:53PM -0700, James Ralston wrote:
> This patch adds the LPC Controller Device IDs for Watchdog and GPIO for the Intel Avoton SoC.
> 
> Signed-off-by: James Ralston <james.d.ralston@intel.com>
> ---
> Change notes for v2:
> *corrected version number
> 
>  drivers/mfd/lpc_ich.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
Applied to my mfd-next tree, it should make it to Linux 3.11.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
