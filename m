Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbaIHC6Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 22:58:25 -0400
Received: from mail-yh0-f43.google.com ([209.85.213.43]:42187 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbaIHC6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 22:58:24 -0400
Date: Sun, 7 Sep 2014 22:54:26 -0400
From: Jon Mason <jdmason@kudzu.us>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] NTB bug fixes and hardware workarounds
Message-ID: <20140908025425.GA11750@kudzu.us>
References: <20140828204947.165750.64364.stgit@djiang5-desk2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140828204947.165750.64364.stgit@djiang5-desk2.amr.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 01:52:57PM -0700, Dave Jiang wrote:
> The following series contains various fixes and cleanup for NTB. It also
> adds the split BAR support on Haswell platform and a hardware errata
> workaround in order to allow interrupts to function during bi-directional
> traffic under stress. 

Accepted all but the last one.

Thanks,
Jon

> 
> ---
> 
> Dave Jiang (6):
>       ntb: Add alignment check to meet hardware requirement
>       ntb: move platform detection to separate function
>       ntb: conslidate reading of PPD to move platform detection earlier
>       ntb: use errata flag set via DID to implement workaround
>       ntb: Adding split BAR support for Haswell platforms
>       ntb: workaround for high traffic hardware hang
> 
> 
>  drivers/ntb/ntb_hw.c        |  603 +++++++++++++++++++++++++++++++++++--------
>  drivers/ntb/ntb_hw.h        |   27 ++
>  drivers/ntb/ntb_regs.h      |   32 ++
>  drivers/ntb/ntb_transport.c |  139 ++++++----
>  4 files changed, 620 insertions(+), 181 deletions(-)
