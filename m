Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650AbaB1Ldx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 06:33:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbaB1Ldv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 06:33:51 -0500
Date: Fri, 28 Feb 2014 12:35:48 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Jon Mason <jon.mason@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 1/4] ntb: Fix leakage of ntb_device::msix_entries[]
 array
Message-ID: <20140228113547.GA4447@dhcp-26-207.brq.redhat.com>
References: <cover.1392996332.git.agordeev@redhat.com>
 <7f4150adb1b01e79555af6a9e13f1c0e0df6fdac.1392996332.git.agordeev@redhat.com>
 <20140221233325.GB3112@jonmason-lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140221233325.GB3112@jonmason-lab>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 04:33:25PM -0700, Jon Mason wrote:
> On Fri, Feb 21, 2014 at 04:49:29PM +0100, Alexander Gordeev wrote:
> > Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> > Cc: Jon Mason <jon.mason@intel.com>
> > Cc: linux-pci@vger.kernel.org
> 
> Good catch.  Applied.

Hi Jon,

If the other three patches are okay?

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
