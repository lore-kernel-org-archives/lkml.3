Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699Ab3DPHwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 03:52:18 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:62368 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283Ab3DPHwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 03:52:17 -0400
Date: Tue, 16 Apr 2013 09:52:12 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <peterz@infradead.org>, jolsa@redhat.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [build error] perf/urgent broken due to
 INTEL_UEVENT_PEBS_LDLAT_EXTRA_REG
Message-ID: <20130416075212.GA6565@gmail.com>
References: <alpine.DEB.2.02.1304152002150.3952@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1304152002150.3952@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Rientjes <rientjes@google.com> wrote:

> Commit 3de4ad210387 ("perf/x86: Fix offcore_rsp valid mask for SNB/IVB") in 
> perf/urgent breaks the build:

Hm, that's was me resolving the conflicts incorrectly.

Stephane, mind sending a tested version of the patch against current -git that can 
be applied to v3.9 and can be backported?

Thanks,

	Ingo
