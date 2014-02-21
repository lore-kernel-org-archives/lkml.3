Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695AbaBUQHm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 11:07:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932264AbaBUQHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 11:07:40 -0500
Date: Fri, 21 Feb 2014 17:09:38 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jon Mason <jon.mason@intel.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 0/4] ntb: Use pci_enable_msix_range() instead of
 pci_enable_msix()
Message-ID: <20140221160937.GA913@dhcp-26-207.brq.redhat.com>
References: <cover.1392996332.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1392996332.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 04:49:28PM +0100, Alexander Gordeev wrote:
> Hi Jon,
> 
> This is an attempt to make ntb_setup_msix() more readable ( to me :) )
> 
> The idea is to get rid of confusing branching between SNB and BWD
> and split MSI-X ininialization into ntb_setup_bwd_msix() and
> ntb_setup_snb_msix() - both small and straight.

Ouch, I was too fast. Patch #3 introduces warning "unused variable ‘msix’"
I can re-post if you want, but the rest is still is up to review ;)

Thanks!

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
