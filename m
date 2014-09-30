Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbaI3GNJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 02:13:09 -0400
Received: from ozlabs.org ([103.22.144.67]:33433 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbaI3GNG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 02:13:06 -0400
Message-ID: <1412057581.19209.2.camel@ale.ozlabs.ibm.com>
Subject: Re: [PATCH 08/15] powerpc/mm: Add new hash_page_mm()
From: Michael Neuling <mikey@neuling.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: greg@kroah.com, arnd@arndb.de, mpe@ellerman.id.au,
        benh@kernel.crashing.org, anton@samba.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, jk@ozlabs.org,
        imunsie@au1.ibm.com, cbe-oss-dev@lists.ozlabs.org
Date: Tue, 30 Sep 2014 16:13:01 +1000
In-Reply-To: <1412054407.1733.77.camel@ale.ozlabs.ibm.com>
References: <1411028820-29933-1-git-send-email-mikey@neuling.org>
	 <1411028820-29933-9-git-send-email-mikey@neuling.org>
	 <87wq8mq07u.fsf@linux.vnet.ibm.com>
	 <1412054407.1733.77.camel@ale.ozlabs.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > You also added code to handle KERNEL_REGION_ID in
> > [PATCH 02/15] powerpc/cell: Move data segment faulting code out of cell
> > platform. do we need to handle that here ?
> > 

(Sorry missed this on my other reply...)

I've refactored that code now so it should be handled in the vsid
calculation.  It's not my strong area so you might wanna check on
repost.

Thanks again.

Mikey

