Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960AbaGNTWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 15:22:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:59179 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756501AbaGNTW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 15:22:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,659,1400050800"; 
   d="scan'208";a="561676774"
Message-ID: <1405365737.8046.164.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [PATCH v2 0/2] xen: Silence compiler warnings
From: Matt Fleming <matt.fleming@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Daniel Kiper <daniel.kiper@oracle.com>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, <xen-devel@lists.xenproject.org>,
        <andrew.cooper3@citrix.com>, <boris.ostrovsky@oracle.com>,
        <david.vrabel@citrix.com>, <hpa@zytor.com>, <ian.campbell@citrix.com>,
        <jbeulich@suse.com>, <jeremy@goop.org>, <mingo@redhat.com>,
        <stefano.stabellini@eu.citrix.com>, <tglx@linutronix.de>
Date: Mon, 14 Jul 2014 20:22:17 +0100
In-Reply-To: <20140714152641.GB6386@laptop.dumpdata.com>
References: <1405199388-5692-1-git-send-email-daniel.kiper@oracle.com>
	 <20140714152641.GB6386@laptop.dumpdata.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [163.33.239.180]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-14 at 11:26 -0400, Konrad Rzeszutek Wilk wrote:
> 
> Hey Matt,
> 
> David Vrabel (who reviewed them earlier and is also an maintainer
> of the Xen tree) is out on vacation so I am responding here.
> 
> I reviewed the patches and hopefully my mailer (Android phone)
> sent it correctly. If not, all of them can have the Reviewed-by:
> Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> tag on them.
> 
> If you would be so kind and pull them in your git tree -
> that would be appreciated!

Sure, I'll do that. Thanks.

