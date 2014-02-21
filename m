Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933271AbaBUQyP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 11:54:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933241AbaBUQyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 11:54:08 -0500
Date: Fri, 21 Feb 2014 17:56:07 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH] timberdale: Use pci_enable_msix_range() instead of
 pci_enable_msix()
Message-ID: <20140221165606.GH17353@dhcp-26-207.brq.redhat.com>
References: <1392804931-30671-3-git-send-email-agordeev@redhat.com>
 <20140219114424.GD10504@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140219114424.GD10504@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee et al,

Based on recently accepted to the mainline pci_enable_msix_exact() function,
I am sending an updated version of the patch. Please, let me know if it does
not work for you and you need and incremental update from the previous version.

Thanks!

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
