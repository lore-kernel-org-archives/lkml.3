Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbaJBDNj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 23:13:39 -0400
Received: from ozlabs.org ([103.22.144.67]:53601 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbaJBDNi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 23:13:38 -0400
Message-ID: <1412219615.19209.97.camel@ale.ozlabs.ibm.com>
Subject: Re: [PATCH v2 05/17] powerpc/mm: Export mmu_kernel_ssize and
 mmu_linear_psize
From: Michael Neuling <mikey@neuling.org>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: greg@kroah.com, arnd@arndb.de, benh@kernel.crashing.org, anton@samba.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, jk@ozlabs.org,
        imunsie@au.ibm.com, cbe-oss-dev@lists.ozlabs.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Date: Thu, 02 Oct 2014 13:13:35 +1000
In-Reply-To: <20141001071332.A61A614017E@ozlabs.org>
References: <20141001071332.A61A614017E@ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-01 at 17:13 +1000, Michael Ellerman wrote:
> On Tue, 2014-30-09 at 10:34:54 UTC, Michael Neuling wrote:
> > From: Ian Munsie <imunsie@au1.ibm.com>
> 
> Mind explaining why ? :)

Sure.

Mikey
