Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab3KGWay (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 17:30:54 -0500
Received: from mga09.intel.com ([134.134.136.24]:14183 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751Ab3KGWar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 17:30:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="405295496"
Date: Thu, 7 Nov 2013 14:30:46 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        gregkh@linuxfoundation.org, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, tglx@linutronix.de,
        Ingo Molnar <mingo@kernel.org>, Steve Capper <steve.capper@linaro.org>
Subject: Re: [RFC PATCH 0/4] wire up CPU features to udev based module loading
Message-ID: <20131107223046.GK1962@tassilo.jf.intel.com>
References: <1383844657-17487-1-git-send-email-ard.biesheuvel@linaro.org>
 <527C0195.50008@zytor.com>
 <20131107213944.GJ1962@tassilo.jf.intel.com>
 <CAKv+Gu9W-Pu4DGgB-85A3D4Ps9_FLSQgyK3EM7=k7KE1=xsnwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9W-Pu4DGgB-85A3D4Ps9_FLSQgyK3EM7=k7KE1=xsnwg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> - the module aliases host tool has no arch specific dependencies at
> all except having x86cpu as one of the entries: would you mind
> dropping the x86 prefix there? Or rather add dependencies on $ARCH?
> (If we drop it there, we basically end up with 'cpu:' everywhere)

Should be fine.

> - in the vendor/family/model case, it may be preferable to drop these
> fields entirely from certain modules' aliases if they match on 'any'
> (provided that the module tools permit this) rather than add
> architecture, variant, revision, etc  fields for all architectures if
> they can only ever match on one

The module tools require everything matching with the same wild cards.

So I don't know how "any" would work.

-Andi
