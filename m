Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab3BCRB5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 12:01:57 -0500
Received: from mga01.intel.com ([192.55.52.88]:64415 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753102Ab3BCRBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 12:01:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,595,1355126400"; 
   d="scan'208";a="282235211"
Date: Sun, 3 Feb 2013 18:01:50 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Roger Quadros <rogerq@ti.com>
Cc: balbi@ti.com, tony@atomide.com, kishon@ti.com, sshtylyov@mvista.com,
        bjorn@mork.no, linux@arm.linux.org.uk, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v9 00/20] OMAP USB Host cleanup
Message-ID: <20130203170150.GN8476@sortiz-mobl>
References: <1358937492-8129-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358937492-8129-1-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

On Wed, Jan 23, 2013 at 12:37:52PM +0200, Roger Quadros wrote:
> Hi Samuel,
> 
> I think this series is in a pretty good shape to pull now :). I've added
> Reviewed-by and Acked-by tags. You can please pull from below.
> 
> NOTE: the first patch is a stable fix so Greg KH might want to pick it up for 3.8-rc.
> 
> The following changes since commit 7d1f9aeff1ee4a20b1aeb377dd0f579fe9647619:
> 
>   Linux 3.8-rc4 (2013-01-17 19:25:45 -0800)
> 
> are available in the git repository at:
>   git://github.com/rogerq/linux.git linux-usbhost14-part
> 
> This patchset addresses the following
> 
> - Consolidate USB Host platform data.
> - Avoid addressing clocks one by one by name and use a for loop + bunch
>   of cleanups.
> - Get number of channels/ports dynamically either from revision register
>   or from platform data. Avoids getting clocks that are not present.
> - Add OMAP5 and HSIC mode (Not tested).
> 
> v9:
> - Addressed clock framework related comments from Russell King.
> - Removed 2 clock data patches from the series as they will be taken care
>   of by Paul Walmsey.
Applied all 20 patches, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
