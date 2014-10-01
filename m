Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357AbaJAGwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 02:52:17 -0400
Received: from gate.crashing.org ([63.228.1.57]:45955 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbaJAGwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 02:52:16 -0400
Message-ID: <1412146289.4285.202.camel@pasglop>
Subject: Re: [PATCH v2 02/17] powerpc/cell: Move data segment faulting code
 out of cell platform
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michael Neuling <mikey@neuling.org>, greg@kroah.com, arnd@arndb.de,
        anton@samba.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        jk@ozlabs.org, imunsie@au.ibm.com, cbe-oss-dev@lists.ozlabs.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Date: Wed, 01 Oct 2014 16:51:29 +1000
In-Reply-To: <20141001064757.BFF88140174@ozlabs.org>
References: <20141001064757.BFF88140174@ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-01 at 16:47 +1000, Michael Ellerman wrote:
> 
> If we give it a name that says what it does, we get
> copro_get_ea_esid_and_vsid().
> Or something equally ugly.

copro_calc_full_va() ?

Ben.


