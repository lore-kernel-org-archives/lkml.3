Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933770AbaKMRsA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 12:48:00 -0500
Received: from mga09.intel.com ([134.134.136.24]:12637 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933526AbaKMRr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 12:47:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,379,1413270000"; 
   d="scan'208";a="607376142"
Message-ID: <1415900840.19506.1.camel@theros.lm.intel.com>
Subject: Re: [PATCH 3/6] x86: Add support for the clwb instruction
From: Ross Zwisler <ross.zwisler@linux.intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "Anvin, H Peter" <h.peter.anvin@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "x86@kernel.org" <x86@kernel.org>
Date: Thu, 13 Nov 2014 10:47:20 -0700
In-Reply-To: <20141112141250.GE16807@pd.tnic>
References: <1415731396-19364-1-git-send-email-ross.zwisler@linux.intel.com>
	 <1415731396-19364-4-git-send-email-ross.zwisler@linux.intel.com>
	 <20141112123909.GD16807@pd.tnic>
	 <C40DC70F50313144AB3AF8625D4F407F71D61056@ORSMSX101.amr.corp.intel.com>
	 <20141112141250.GE16807@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20.rez) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-12 at 15:12 +0100, Borislav Petkov wrote:
> On Wed, Nov 12, 2014 at 01:38:45PM +0000, Anvin, H Peter wrote:
> > No, it doesn't.  x86 requires 3.4+ at a minimum.
> 
> The only test I see is:
> 
> #if GCC_VERSION < 30200
> # error Sorry, your compiler is too old - please upgrade it.
> #endif
> 
> And even if we do require 3.4, the build fails with 4.1+ so...

Ah, dang, you're right.  Okay, I'll figure out how to do this without
using xsaveopt.

Thank you for pointing this out.

- Ross

