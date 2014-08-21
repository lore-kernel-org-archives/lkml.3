Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbaHUHBH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 03:01:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:21639 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753672AbaHUHBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 03:01:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,907,1400050800"; 
   d="scan'208";a="591188663"
From: Jani Nikula <jani.nikula@intel.com>
To: Rusty Russell <rusty@rustcorp.com.au>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Jean Delvare <khali@linux-fr.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Jon Mason <jon.mason@intel.com>
Subject: Re: [PATCH 0/4] module: add support for unsafe, tainting parameters
In-Reply-To: <87ppfvi1hx.fsf@rustcorp.com.au>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <cover.1407764272.git.jani.nikula@intel.com> <87wqac87dq.fsf@rustcorp.com.au> <CAKMK7uGrT6jvsetM2av26CBEgQBv4b9asAP9kGN_-WdtT1bdkQ@mail.gmail.com> <87ppfvi1hx.fsf@rustcorp.com.au>
User-Agent: Notmuch/0.18.1+66~g7487985 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Thu, 21 Aug 2014 10:00:48 +0300
Message-ID: <87oavemin3.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Aug 2014, Rusty Russell <rusty@rustcorp.com.au> wrote:
> I've applied this cleanup on top, however.
>
> Cheers,
> Rusty.
>
> Subject: param: check for tainting before calling set op.
>
> This means every set op doesn't need to call it, and it can move into
> params.c.

Much better, thanks. I was looking for a way to do something like this,
but obviously didn't look hard enough.

BR,
Jani.


-- 
Jani Nikula, Intel Open Source Technology Center
