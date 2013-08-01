Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704Ab3HATuG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 15:50:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:54090 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754478Ab3HATuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 15:50:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,796,1367996400"; 
   d="scan'208";a="355697374"
Date: Thu, 1 Aug 2013 12:50:10 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>,
        "Pandruvada, Srinivas" <srinivas.pandruvada@intel.com>
Subject: Re: [PATCH] x86/msr: add 64bit _on_cpu access functions
Message-ID: <20130801125010.0c374d17@chromoly>
In-Reply-To: <277225b8-a264-4d85-aace-d9199e1573b1@email.android.com>
References: <1375352553-5695-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<277225b8-a264-4d85-aace-d9199e1573b1@email.android.com>
Organization: OTC
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Aug 2013 12:31:07 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> The patch is fine but please use it asa preface to a patch series
> that actually used these interfaces.
will do.
It will be used for upcoming Intel RAPL driver. I was hoping to avoid
time consuming rebuild of the entire kernel when the patchset touches
msr.h.

-- 
Thanks,

Jacob
