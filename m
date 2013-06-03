Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182Ab3FCJoJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 05:44:09 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:1738 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab3FCJoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 05:44:07 -0400
X-IronPort-AV: E=Sophos;i="4.87,791,1363132800"; 
   d="scan'208";a="5249711"
Message-ID: <1370252643.11717.27.camel@zakaz.uk.xensource.com>
Subject: Re: DTB build failure due to preproccessing
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Michal Marek <mmarek@suse.cz>, "Stephen Warren" <swarren@nvidia.com>,
        Rob Herring <rob.herring@calxeda.com>, JonLoeliger <jdl@jdl.com>,
        <linux-kbuild@vger.kernel.org>
Date: Mon, 3 Jun 2013 10:44:03 +0100
In-Reply-To: <CACxGe6vWtofRb3ysPueJ73e3O18vNegiLapcTg_JZ9eRmPL5BA@mail.gmail.com>
References: <1369996170.5199.68.camel@zakaz.uk.xensource.com>
	 <20130531114824.60D223E0901@localhost> <51A8CA15.4070504@wwwdotorg.org>
	 <CACxGe6vWtofRb3ysPueJ73e3O18vNegiLapcTg_JZ9eRmPL5BA@mail.gmail.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.203.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-05-31 at 17:31 +0100, Grant Likely wrote:
> On Fri, May 31, 2013 at 5:04 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> > On 05/31/2013 05:48 AM, Grant Likely wrote:
> >> ---
> >> commit d01dccdcb3ea8233b09efb9c24db9f057fbd3b37
> >> Author: Grant Likely <grant.likely@linaro.org>
> >> Date:   Fri May 31 12:45:18 2013 +0100
> >>
> >>     dtc: Suppress cpp linemarker annotations
> >>
> >>     DTC isn't able to parse cpp linemarker annotations, so suppress them in
> >>     the cpp output by adding the -P flag to the cpp options.
> >
> > That's not true; it explicitly does have code to parse the line markers.
> > I'll have to investigate why it isn't working in this case.
> >
> > If you apply this patch, then anyone who has switched to #include rther
> > than /include/ will get incorrect line numbers in dtc error messages.
> > Admittedly that's a smaller population right now though. Perhaps we
> > should just do a kernel-wide conversion though.
> 
> My mistake. I tested the wrong thing. I've dropped the patch.

FWIW I've also dropped it from my device-tree.git tree.

Ian.


