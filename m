Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbaDGBWk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 21:22:40 -0400
Received: from ozlabs.org ([203.10.76.45]:54738 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754266AbaDGBWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 21:22:38 -0400
Date: Mon, 7 Apr 2014 11:22:36 +1000
From: Anton Blanchard <anton@samba.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Cody P Schafer <cody@linux.vnet.ibm.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        cody+local@linux.vnet.ibm.com, LKML <linux-kernel@vger.kernel.org>,
        David.Laight@aculab.com
Subject: Re: [PATCH 1/2] fixup: "powerpc/perf: Add support for the hv 24x7
 interface"
Message-ID: <20140407112236.3d65d99b@kryten>
In-Reply-To: <1396828110.3671.21.camel@pasglop>
References: <1396476654-20623-1-git-send-email-cody@linux.vnet.ibm.com>
	<1396476654-20623-2-git-send-email-cody@linux.vnet.ibm.com>
	<1396828110.3671.21.camel@pasglop>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> That's not much less awful... The message gives 0 informations about
> where it comes from .. what is it that couldn't obtain capabilities ?

Cody is at least using pr_fmt to give some information on what went
wrong:

[    1.635040] hv-24x7: not a virtualized system, not enabling
[    1.635079] hv-gpci: not a virtualized system, not enabling

I think this is way too chatty though. If every driver printed a couple
of lines we'd end up with thousands of useless lines in the dmesg.

I still would prefer to see these as pr_debug lines.

Anton
