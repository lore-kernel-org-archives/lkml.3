Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934554Ab3FSKGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 06:06:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933830Ab3FSKGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 06:06:06 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1371483967-22527-1-git-send-email-ddaney.cavm@gmail.com>
References: <1371483967-22527-1-git-send-email-ddaney.cavm@gmail.com> <1371413189-2568-3-git-send-email-ddaney.cavm@gmail.com>
To: ddaney.cavm@gmail.com
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-ia64@vger.kernel.org,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        linux-am33-list@redhat.com, david.s.daney@gmail.com,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH v2] mn10300: Fix include dependency in irqflags.h et al.
Date: Wed, 19 Jun 2013 11:05:52 +0100
Message-ID: <899.1371636352@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ddaney.cavm@gmail.com wrote:

> From: David Daney <david.daney@cavium.com>
> 
> We need to pick up the definition of raw_smp_processor_id() from
> asm/smp.h.  For the !SMP case, we need to supply a definition of
> raw_smp_processor_id().
> 
> Because of the include dependencies we cannot use smp_call_func_t in
> asm/smp.h, but we do need linux/thread_info.h
> 
> Signed-off-by: David Daney <david.daney@cavium.com>

Acked-by: David Howells <dhowells@redhat.com>
