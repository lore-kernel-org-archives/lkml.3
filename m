Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbaESXg6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 19:36:58 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:11306 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751347AbaESXg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 19:36:56 -0400
X-IronPort-AV: E=Sophos;i="4.98,870,1392159600"; 
   d="scan'208";a="74710252"
Date: Tue, 20 May 2014 07:36:48 +0800 (SGT)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Dan Carpenter <dan.carpenter@oracle.com>
cc: Saurav Kashyap <saurav.kashyap@qlogic.com>,
        Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@qlogic.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/13 v2] [SCSI] qla2xxx: make return of 0 explicit
In-Reply-To: <20140519201202.GA15585@mwanda>
Message-ID: <alpine.DEB.2.10.1405200735210.3003@hadrien>
References: <1400474832-22422-1-git-send-email-Julia.Lawall@lip6.fr> <F5D084D6342F9B479C34599BB0A03E4D01284E742E@AVMB1.qlogic.org> <20140519201202.GA15585@mwanda>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 19 May 2014, Dan Carpenter wrote:

> On Mon, May 19, 2014 at 04:07:52PM +0000, Saurav Kashyap wrote:
> > Hi Julia,
> >
> > Status is already set to 0 at the beginning of the function, I think
> > we should just "return status" here to be consistent with the rest of
> > the function.
>
> "return 0;" is more clear than "return status;".
>
> Consistency is great so long as it makes the code easier to read.  Don't
> lose track of the real goal.

If status were an informative word, there might be a reason for it.  But
integer typed functions almost always return their status, so there is no
real information.

julia
