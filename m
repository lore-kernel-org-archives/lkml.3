Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbaGBEGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 00:06:49 -0400
Received: from ozlabs.org ([103.22.144.67]:60402 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbaGBEGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 00:06:48 -0400
Message-ID: <1404274005.7254.0.camel@concordia>
Subject: Re: [PATCH V3] powerpc/powernv: Check for IRQHAPPENED before
 sleeping
From: Michael Ellerman <mpe@ellerman.id.au>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: benh@kernel.crashing.org, mikey@neuling.org, shreyas@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Date: Wed, 02 Jul 2014 14:06:45 +1000
In-Reply-To: <20140702034811.2956.30873.stgit@preeti.in.ibm.com>
References: <20140702034811.2956.30873.stgit@preeti.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-02 at 09:19 +0530, Preeti U Murthy wrote:
> Commit 8d6f7c5a: "powerpc/powernv: Make it possible to skip the IRQHAPPENED
> check in power7_nap()" added code that prevents cpus from checking for
> pending interrupts just before entering sleep state, which is wrong. These
> interrupts are delivered during the soft irq disabled state of the cpu.

Acked-by: Michael Ellerman <mpe@ellerman.id.au>

cheers


