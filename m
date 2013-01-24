Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab3AXPqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 10:46:44 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:61223 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab3AXPqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 10:46:42 -0500
Date: Thu, 24 Jan 2013 16:46:37 +0100
From: Ingo Molnar <mingo@kernel.org>
To: markus.t.metzger@intel.com
Cc: mingo@redhat.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
        Mark Kettenis <kettenis@gnu.org>, Pedro Alves <palves@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>, gdb-patches@sourceware.org
Subject: Re: [PATCH] x86, perf, bts: disable BTS from Nehalem to Ivy Bridge
Message-ID: <20130124154637.GB32146@gmail.com>
References: <1354876511-25294-1-git-send-email-markus.t.metzger@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354876511-25294-1-git-send-email-markus.t.metzger@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* markus.t.metzger@intel.com <markus.t.metzger@intel.com> wrote:

> From: Markus Metzger <markus.t.metzger@intel.com>
> 
> Starting with Nehalem, the BTS "from" information may in some cases be
> incorrect (AAJ122).
> 
> This has been detected while adding branch tracing support to gdb, where it
> results in sporadic test fails.
> 
> Disable BTS support on Nehalem, Westmere, Sandy Bridge, and Ivy Bridge.

But the failures are rare, so the BTS data is still correct 
statistically, by and large, right? So why not just keep it 
as-is and teach tooling to be more robust about implausible 
trace entries? It has to be ready for that eventuality *anyway*.

Thanks,

	Ingo
