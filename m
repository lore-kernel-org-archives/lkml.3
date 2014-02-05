Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbaBEXOU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 18:14:20 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:42897 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbaBEXOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 18:14:18 -0500
Message-ID: <52F2C5BE.5080803@linux.vnet.ibm.com>
Date: Wed, 05 Feb 2014 15:14:06 -0800
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>,
        Linux PPC <linuxppc-dev@lists.ozlabs.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 4/8] powerpc: add hv_gpci interface header
References: <20140201055807.267F12C00BA@ozlabs.org>
In-Reply-To: <20140201055807.267F12C00BA@ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020523-0928-0000-0000-0000064A018A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> diff --git a/arch/powerpc/include/asm/hv_gpci.h b/arch/powerpc/include/asm/hv_gpci.h
>
> Any reason this can't just live in arch/powerpc/perf ?
>

Nope, it should be able to keep the header there for now. As this 
interface allows determination of the HW topology, we may have some code 
that exposes that (in sysfs) at some point, which doesn't really belong 
in arch/powerpc/perf (though we could just put it there anyhow).

