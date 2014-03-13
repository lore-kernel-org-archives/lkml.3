Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488AbaCMRSX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 13:18:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:47190 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754290AbaCMRSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 13:18:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,648,1389772800"; 
   d="scan'208";a="499328364"
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        zheng.z.yan@intel.com, bp@alien8.de
Subject: Re: [PATCH] perf/x86/uncore: fix missing end markers for SNB/IVB/HSW IMC PMU
References: <20140313120436.GA14236@quad>
Date: Thu, 13 Mar 2014 10:17:07 -0700
In-Reply-To: <20140313120436.GA14236@quad> (Stephane Eranian's message of
	"Thu, 13 Mar 2014 13:04:36 +0100")
Message-ID: <87wqfyf27g.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane Eranian <eranian@google.com> writes:

> This patch fixes a bug with the SNB/IVB/HSW uncore
> mmeory controller support.
>
> The PCI Ids tables for the memory controller were missing end markers.
> That could cause random crashes on boot during or after PCI device
> registration.

I wonder if there's a way to check this in checkpatch.pl ?

Or maybe a sparse check could be added, with a new type attribute 
that says "needs to be 0 terminate"

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
