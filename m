Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab3GJKjj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 06:39:39 -0400
Received: from gate.crashing.org ([63.228.1.57]:42679 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561Ab3GJKjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 06:39:37 -0400
Message-ID: <1373452753.19894.19.camel@pasglop>
Subject: Re: [PATCH 8/8] KVM: PPC: Add hugepage support for IOMMU in-kernel
 handling
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alexander Graf <agraf@suse.de>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org
Date: Wed, 10 Jul 2013 20:39:13 +1000
In-Reply-To: <778C7C81-5F7F-4E21-8B72-92F336002F9E@suse.de>
References: <1373123227-22969-1-git-send-email-aik@ozlabs.ru>
	 <1373123227-22969-9-git-send-email-aik@ozlabs.ru>
	 <51DC4923.5010501@suse.de> <51DC9CDA.3070906@ozlabs.ru>
	 <778C7C81-5F7F-4E21-8B72-92F336002F9E@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-10 at 12:33 +0200, Alexander Graf wrote:
> 
> It's not exactly obvious that you're calling it with writing == 1 :).
> Can you create a new local variable "is_write" in the calling
> function, set that to 1 before the call to get_user_pages_fast and
> pass it in instead of the 1? The compiler should easily optimize all
> of that away, but it makes the code by far easier to read.

Ugh ?

Nobody else does that .... (look at futex :-)

Ben.


