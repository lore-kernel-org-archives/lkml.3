Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbaAOCmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 21:42:18 -0500
Received: from ozlabs.org ([203.10.76.45]:51157 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637AbaAOCmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 21:42:15 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <ak@linux.intel.com>, Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH] export: declare ksymtab symbols
In-Reply-To: <20131217163259.GB22695@tassilo.jf.intel.com>
References: <1387273136-31449-1-git-send-email-johannes@sipsolutions.net> <20131217163259.GB22695@tassilo.jf.intel.com>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Wed, 15 Jan 2014 10:16:43 +1030
Message-ID: <87a9eyxh24.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@linux.intel.com> writes:
>> Cc: Andi Kleen <ak@linux.intel.com>
>> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>
> Acked-by: Andi Kleen <ak@linux.intel.com>

Thanks, applied.

I added:

Fixes: e0f244c63fc9 ("asmlinkage, module: Make ksymtab [...] __visible")

Cheers,
Rusty.
