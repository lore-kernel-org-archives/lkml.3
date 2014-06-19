Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966074AbaFSXEr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 19:04:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:16094 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964958AbaFSXEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 19:04:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,509,1400050800"; 
   d="scan'208";a="531265655"
Message-ID: <1403219058.10778.72.camel@acox1-desk.ger.corp.intel.com>
Subject: Re: Cannot partition 32GB disk on a 32bit machine (correct version
 of the patch this time)
From: Alan Cox <alan@linux.intel.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "aeb@cwi.nl" <aeb@cwi.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 20 Jun 2014 00:04:18 +0100
In-Reply-To: <1403203437.17294.25.camel@dabdike.int.hansenpartnership.com>
References: <1403170201.10778.36.camel@acox1-desk.ger.corp.intel.com>
	 <1403170400.10778.38.camel@acox1-desk.ger.corp.intel.com>
	 <1403203437.17294.25.camel@dabdike.int.hansenpartnership.com>
Organization: Intel Corporation
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Wow that's junk issued by an Exchange server ... Alan, really ...

Blame evolution. It apparently thinks that if you follow up to your own
email from one address it should randomly switch to another.

> Do you have CONFIG_LBD turned on?  That's supposed to let us go up to
> about 16TB before we run out of page index bits.  If you do, we might
> have a variable that's int but should be sector_t somewhere.

LBDAF is set



