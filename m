Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbaCYKn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 06:43:58 -0400
Received: from ozlabs.org ([203.10.76.45]:51854 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469AbaCYKn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 06:43:57 -0400
Date: Tue, 25 Mar 2014 21:43:56 +1100
From: Anton Blanchard <anton@samba.org>
To: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        scottwood@freescale.com
Subject: Re: [PATCH v4 09/11] powerpc/perf: add support for the hv 24x7
 interface
Message-ID: <20140325214356.4a2f7d95@kryten>
In-Reply-To: <1394064082-6242-10-git-send-email-cody@linux.vnet.ibm.com>
References: <1394064082-6242-1-git-send-email-cody@linux.vnet.ibm.com>
	<1394064082-6242-10-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Cody,

hv-24x7: could not obtain capabilities, error 0x                                                                fffffffffffffffe, not enabling
hv-gpci: could not obtain capabilities, error 0x                                                                fffffffffffffffe, not enabling

> +		pr_info("could not obtain capabilities, error 0x%80lx, not enabling\n",

That's a lot of padding :)

I think this should also be a pr_debug, considering this is not relevant
to most ppc64 boxes.

Anton
