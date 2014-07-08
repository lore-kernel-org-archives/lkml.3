Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbaGHCpR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 22:45:17 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:48104 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbaGHCpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 22:45:15 -0400
MIME-Version: 1.0
Date: Mon, 7 Jul 2014 22:45:14 -0400
Message-ID: <CAPDOMVi5ptjaKzT+Exd3XtKcy7W7nNZYUD+MEwN8LmhPrQTZBQ@mail.gmail.com>
Subject: Allyesconfig for powerpc still Failing
From: Nick Krause <xerofoify@gmail.com>
To: benh@kernel.crashing.org
Cc: paulus@samba.org, mahesh@linux.vnet.ibm.com, anton@samba.org,
        agraf@suse.de, michael@ellerman.id.au, svaidy@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today I tested the allyesconfig for powerpc and it seems to be still
failing according to my tests.
Below are the error messages I get before the jobs finish and exit
failing the build.
Cheers Nick
arch/powerpc/kernel/exceptions-64s.S: Assembler messages:
arch/powerpc/kernel/exceptions-64s.S:1331: Error: attempt to move .org backwards
make[1]: *** [arch/powerpc/kernel/head_64.o] Error 1
make: *** [arch/powerpc/kernel] Error 2
make: *** Waiting for unfinished jobs....
