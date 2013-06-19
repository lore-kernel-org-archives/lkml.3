Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934438Ab3FSJeI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 05:34:08 -0400
Received: from mga14.intel.com ([143.182.124.37]:59603 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933993Ab3FSJeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 05:34:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,895,1363158000"; 
   d="scan'208";a="257132914"
Date: Wed, 19 Jun 2013 11:34:02 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Pawel Moll <pawel.moll@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH v2] mfd: vexpress: Make the driver optional for arm and
 arm64
Message-ID: <20130619093402.GY7161@zurbaran>
References: <20130610232249.GH18614@n2100.arm.linux.org.uk>
 <1370948162-18895-1-git-send-email-pawel.moll@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370948162-18895-1-git-send-email-pawel.moll@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pawel,

On Tue, Jun 11, 2013 at 11:56:02AM +0100, Pawel Moll wrote:
> The driver can be used on either arm or arm64 platforms, but
> the latter doesn't have any platform-specific configuration
> options, so it must be possible to manually enable the driver.
> 
> As the gpiolib is optional for arm64 arch, the gpio/led code
> must be compiled conditionally.
The real solution would be to move the GPIO code away from the MFD
driver, as we agreed on another thread.
Based on this agreement, I'm taking this one for now, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
