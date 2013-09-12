Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab3ILWbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 18:31:20 -0400
Received: from mga03.intel.com ([143.182.124.21]:27760 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755809Ab3ILWbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 18:31:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,893,1371106800"; 
   d="scan'208";a="294239693"
Message-ID: <1379025052.1285.52.camel@dvhart-mobl4.amr.corp.intel.com>
Subject: Re: [PATCH] Remove warning in efi_enter_virtual_mode
From: Darren Hart <darren.hart@intel.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: "Bryan O'Donoghue" <bryan.odonoghue.lkml@nexus-software.ie>,
        matthew.garrett@nebula.com, linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Josh Boyer <jwboyer@redhat.com>
Date: Thu, 12 Sep 2013 15:30:52 -0700
In-Reply-To: <20130912075500.GC895@console-pimps.org>
References: <1366127886-31460-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie>
	 <516EAC4A.6040202@console-pimps.org> <516F1B90.9040508@nexus-software.ie>
	 <516FD24A.3070502@console-pimps.org> <51700876.1000305@intel.com>
	 <51701D2E.6060903@console-pimps.org> <51708D3D.9010707@intel.com>
	 <5170F736.2060803@console-pimps.org>
	 <1378835007.19978.125.camel@dvhart-mobl4.amr.corp.intel.com>
	 <20130912075500.GC895@console-pimps.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-12 at 08:55 +0100, Matt Fleming wrote:
> On Tue, 10 Sep, at 10:43:27AM, Darren Hart wrote:
> > Josh OK'd this, but as far as I can tell, it hasn't made it upstream
> > yet. Matt was there an alternate fixed pushed?
> 
> Nope, this one slipped through the cracks. Thanks for following up!
> 
> Here's the patch I just applied on the 'urgent' branch.
> 

Excellent, thank you Matt.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel


