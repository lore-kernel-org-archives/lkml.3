Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578AbaFDTTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 15:19:20 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:24254
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750925AbaFDTTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 15:19:19 -0400
X-IronPort-AV: E=Sophos;i="4.98,974,1392159600"; 
   d="scan'208";a="65476315"
Date: Wed, 4 Jun 2014 21:19:13 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
cc: Julia Lawall <Julia.Lawall@lip6.fr>, infinipath <infinipath@intel.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Roland Dreier <roland@kernel.org>,
        "Hefty, Sean" <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 9/10] IB/qib: use safer test on the result of
 find_first_zero_bit
In-Reply-To: <32E1700B9017364D9B60AED9960492BC21BE92E6@fmsmsx120.amr.corp.intel.com>
Message-ID: <alpine.DEB.2.02.1406042118420.1977@localhost6.localdomain6>
References: <1401872880-23685-1-git-send-email-Julia.Lawall@lip6.fr> <1401872880-23685-10-git-send-email-Julia.Lawall@lip6.fr> <32E1700B9017364D9B60AED9960492BC21BE92E6@fmsmsx120.amr.corp.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2014, Marciniszyn, Mike wrote:

> > Subject: [PATCH 9/10] IB/qib: use safer test on the result of find_first_zero_bit
> > 
> > From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Thanks for the patch!
> 
> Roland, I'm marking this as stable since a memory corruption can occur in the _set_bit().

No, it's not necessary.  It turns out that the result cannot be greater 
than the requested maximum value.

julia
