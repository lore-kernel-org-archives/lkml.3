Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440AbaHHK1e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 06:27:34 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:34173 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755900AbaHHK1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 06:27:32 -0400
X-IronPort-AV: E=Sophos;i="5.01,824,1400018400"; 
   d="scan'208";a="88706363"
Date: Fri, 8 Aug 2014 12:27:03 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
cc: Wolfram Sang <wsa@the-dreams.de>, kernel-janitors@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 1/14] i2c: mpc: delete unneeded test before of_node_put
In-Reply-To: <20140808102536.GZ1933@pengutronix.de>
Message-ID: <alpine.DEB.2.10.1408081226400.2348@hadrien>
References: <1407492475-26283-1-git-send-email-Julia.Lawall@lip6.fr> <20140808102536.GZ1933@pengutronix.de>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1811163182-1407493623=:2348"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1811163182-1407493623=:2348
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT



On Fri, 8 Aug 2014, Uwe Kleine-König wrote:

> Hello,
>
> On Fri, Aug 08, 2014 at 12:07:42PM +0200, Julia Lawall wrote:
> > From: Julia Lawall <Julia.Lawall@lip6.fr>
> >
> > Of_node_put supports NULL as its argument, so the initial test is not
> > necessary.
> >
> > Suggested by Uwe Kleine-König.
> Thanks for picking up my suggestion.
>
> > The semantic patch that fixes this problem is as follows:
> > (http://coccinelle.lip6.fr/)
> >
> > // <smpl>
> > @@
> > expression e;
> > @@
> >
> > -if (e)
> >    of_node_put(e);
> > // </smpl>
> >
>
> I added devicetree@vger.kernel.org to Cc. Maybe they want to comment the
> series? If it's acceptable the logical next step is to add the patch to
> the collection of semantic patches, right?

Yes, I will do that.

julia
--8323329-1811163182-1407493623=:2348--
