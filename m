Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924AbaGHDEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 23:04:34 -0400
Received: from gate.crashing.org ([63.228.1.57]:44757 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057AbaGHDEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 23:04:32 -0400
Message-ID: <1404788634.16156.38.camel@pasglop>
Subject: Re: Allyesconfig for powerpc still Failing
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nick Krause <xerofoify@gmail.com>
Cc: paulus@samba.org, mahesh@linux.vnet.ibm.com, anton@samba.org,
        agraf@suse.de, michael@ellerman.id.au, svaidy@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 08 Jul 2014 13:03:54 +1000
In-Reply-To: <CAPDOMVi5ptjaKzT+Exd3XtKcy7W7nNZYUD+MEwN8LmhPrQTZBQ@mail.gmail.com>
References: <CAPDOMVi5ptjaKzT+Exd3XtKcy7W7nNZYUD+MEwN8LmhPrQTZBQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-07 at 22:45 -0400, Nick Krause wrote:
> Today I tested the allyesconfig for powerpc and it seems to be still
> failing according to my tests.
> Below are the error messages I get before the jobs finish and exit
> failing the build.
> Cheers Nick
> arch/powerpc/kernel/exceptions-64s.S: Assembler messages:
> arch/powerpc/kernel/exceptions-64s.S:1331: Error: attempt to move .org backwards
> make[1]: *** [arch/powerpc/kernel/head_64.o] Error 1
> make: *** [arch/powerpc/kernel] Error 2
> make: *** Waiting for unfinished jobs....

Yes, it's a trainwreck and I don't know how to fix it yet ... I tried
various more or less invasive approaches and none of them worked
properly so far. I need to spend more time on this.

Cheers,
Ben.


