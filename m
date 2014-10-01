Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607AbaJAHNr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 03:13:47 -0400
Received: from ozlabs.org ([103.22.144.67]:42949 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbaJAHNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 03:13:34 -0400
In-Reply-To: <1412073306-13812-6-git-send-email-mikey@neuling.org>
To: Michael Neuling <mikey@neuling.org>, greg@kroah.com, arnd@arndb.de,
        mpe@ellerman.id.au, benh@kernel.crashing.org
From: Michael Ellerman <mpe@ellerman.id.au>
Cc: mikey@neuling.org, anton@samba.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, jk@ozlabs.org, imunsie@au.ibm.com,
        cbe-oss-dev@lists.ozlabs.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 05/17] powerpc/mm: Export mmu_kernel_ssize and mmu_linear_psize
Message-Id: <20141001071332.A61A614017E@ozlabs.org>
Date: Wed,  1 Oct 2014 17:13:32 +1000 (EST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-30-09 at 10:34:54 UTC, Michael Neuling wrote:
> From: Ian Munsie <imunsie@au1.ibm.com>

Mind explaining why ? :)

cheers
