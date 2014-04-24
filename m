Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbaDXHXF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 03:23:05 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:53959 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbaDXHW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 03:22:59 -0400
Date: Thu, 24 Apr 2014 09:22:55 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jason Chen <jason.cj.chen@intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] x86/apic: add apic_irqs bitmap to identify irqs
 from apic
Message-ID: <20140424072255.GA3483@gmail.com>
References: <cover.1397838739.git.jason.cj.chen@intel.com>
 <511b8dc7848513496067fb68d979d248f04235ad.1397838739.git.jason.cj.chen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <511b8dc7848513496067fb68d979d248f04235ad.1397838739.git.jason.cj.chen@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jason Chen <jason.cj.chen@intel.com> wrote:

> The function irq_force_complete_move() might handle irqs based on
> the non-apic irq_chip the way apic does, which has the structure
> irq_cfg as its chip_data.
> Wrong operations on non-apic irq_chip might make its chip_data changed
> and bring unexpected issues.
> Add apic_irqs bitmap to identify irqs from apic, and filter out all other
> irq_chips by checking this bitmap.

Please update the changelog to describe the current behavior, and how 
it affects your platform. (I.e. how do users notice, if at all?)

Then describe why you think that behavior should be changed. ie: 
what's the reason for this patch.

Only then describe the details of the change itself.

Thanks,

	Ingo
