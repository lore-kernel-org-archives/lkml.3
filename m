Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480Ab3FQIhc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 04:37:32 -0400
Received: from gate.crashing.org ([63.228.1.57]:36058 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756164Ab3FQIhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 04:37:31 -0400
Message-ID: <1371458225.21896.153.camel@pasglop>
Subject: Re: [PATCH 1/4] KVM: PPC: Add support for multiple-TCE hcalls
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Alexander Graf <agraf@suse.de>, linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@samba.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org
Date: Mon, 17 Jun 2013 18:37:05 +1000
In-Reply-To: <51BEC0FE.4020805@ozlabs.ru>
References: <1370412673-1345-1-git-send-email-aik@ozlabs.ru>
	 <1370412673-1345-2-git-send-email-aik@ozlabs.ru>
	 <0A6C24DE-1422-4ABA-A516-2B864F4714F8@suse.de> <51BEC0FE.4020805@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-17 at 17:55 +1000, Alexey Kardashevskiy wrote:
> David:
> ===
> So, in the case of MULTITCE, that's not quite right.  PR KVM can
> emulate a PAPR system on a BookE machine, and there's no reason not to
> allow TCE acceleration as well.  We can't make it dependent on PAPR
> mode being selected, because that's enabled per-vcpu, whereas these
> capabilities are queried on the VM before the vcpus are created.
> ===
> 
> Wrong?

The capability just tells qemu the kernel supports it, it doesn't have
to depend on PAPR mode, qemu can sort things out no ?

Cheers,
Ben.


