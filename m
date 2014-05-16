Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456AbaEPA05 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 20:26:57 -0400
Received: from ozlabs.org ([103.22.144.67]:39476 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbaEPA04 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 20:26:56 -0400
Message-ID: <1400200013.3797.89.camel@ale.ozlabs.ibm.com>
Subject: Re: [PATCH V2 2/3] powerpc, ptrace: Enable support for
 transactional memory register sets
From: Michael Neuling <mikey@neuling.org>
To: Pedro Alves <palves@redhat.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>, avagin@openvz.org,
        oleg@redhat.com, linux-kernel@vger.kernel.org, michael@ellerman.id.au,
        linuxppc-dev@ozlabs.org
Date: Fri, 16 May 2014 10:26:53 +1000
In-Reply-To: <5374AE24.1030302@redhat.com>
References: <1399276469-13541-1-git-send-email-khandual@linux.vnet.ibm.com>
	 <1399276469-13541-3-git-send-email-khandual@linux.vnet.ibm.com>
	 <537252C0.6090005@redhat.com> <53730326.6000400@linux.vnet.ibm.com>
	 <53735044.5030008@redhat.com> <537479FD.2010200@linux.vnet.ibm.com>
	 <5374AE24.1030302@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So in sum, it very much looks like the intention is for
> PTRACE_GETREGSET/PTRACE_SETREGSET to return ENODEV in the
> case the regset doesn't exist on the running machine, and then
> it looks like at least x86 works that way.

Good point... agreed.  We should ENODEV when we don't have TM hardware
(like POWER7).

Mikey

