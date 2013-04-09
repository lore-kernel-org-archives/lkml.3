Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937443Ab3DIKJj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 06:09:39 -0400
Received: from mga14.intel.com ([143.182.124.37]:34536 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762811Ab3DIKJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 06:09:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,438,1363158000"; 
   d="scan'208";a="283586912"
Date: Tue, 9 Apr 2013 12:09:35 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Pawel Moll <pawel.moll@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] mfd: vexpress: Give the "leds-gpio" device a real parent
Message-ID: <20130409100935.GS24058@zurbaran>
References: <1364991987-6598-1-git-send-email-pawel.moll@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364991987-6598-1-git-send-email-pawel.moll@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pawel,

On Wed, Apr 03, 2013 at 01:26:27PM +0100, Pawel Moll wrote:
> The registration of the "leds-gpio" device was using
> "vexpress_sysreg_dev" as a parent before it was actually
> set to something different than NULL.
> 
> Trivial fix by reordering the code.
> 
> Reported-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> ---
>  drivers/mfd/vexpress-sysreg.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
