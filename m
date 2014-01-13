Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693AbaAMKq6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 05:46:58 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:47940 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbaAMKq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 05:46:56 -0500
Date: Mon, 13 Jan 2014 11:46:47 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Baruch Siach <baruch@tkos.co.il>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org
Subject: Re: [PATCH v3] perf: add support for the xtensa architecture
Message-ID: <20140113104647.GA16230@gmail.com>
References: <aafcdb22f04e2d3188d2938528939481be56b649.1389608855.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aafcdb22f04e2d3188d2938528939481be56b649.1389608855.git.baruch@tkos.co.il>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Baruch Siach <baruch@tkos.co.il> wrote:

> Tested using kernel tracepoints on a QEMU simulated environment. Kernel support
> for perf depends on the patch "xtensa: enable HAVE_PERF_EVENTS", which is
> scheduled for v3.14. Hardware performance counters are not supported under
> xtensa yet.
> 
> Acked-by: Max Filippov <jcmvbkbc@gmail.com>
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
