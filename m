Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbaLEIkL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 03:40:11 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:44738 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751604AbaLEIkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 03:40:09 -0500
X-IronPort-AV: E=Sophos;i="5.07,521,1413237600"; 
   d="scan'208";a="111425923"
Date: Fri, 5 Dec 2014 09:40:01 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: SF Markus Elfring <elfring@users.sourceforge.net>
cc: Julia Lawall <julia.lawall@lip6.fr>, Joe Perches <joe@perches.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Paul Mackerras <paulus@samba.org>, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2 1/6] net-PPP: Replacement of a printk() call by
 pr_warn() in mppe_rekey()
In-Reply-To: <54816700.6090501@users.sourceforge.net>
Message-ID: <alpine.DEB.2.10.1412050939360.2360@hadrien>
References: <5307CAA2.8060406@users.sourceforge.net>  <530B5FB6.6010207@users.sourceforge.net>  <alpine.DEB.2.10.1402241710370.2074@hadrien>  <530C5E18.1020800@users.sourceforge.net>  <alpine.DEB.2.10.1402251014170.2080@hadrien>  <530CD2C4.4050903@users.sourceforge.net>
  <alpine.DEB.2.10.1402251840450.7035@hadrien>  <530CF8FF.8080600@users.sourceforge.net>  <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>  <530DD06F.4090703@users.sourceforge.net>  <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> 
 <5317A59D.4@users.sourceforge.net> <547C5CBC.6060607@cogentembedded.com>  <547C82A6.2030808@users.sourceforge.net>  <547CA157.1080401@cogentembedded.com>  <5480DA32.8000201@users.sourceforge.net>  <5480DBDE.7040604@users.sourceforge.net> 
 <1417731809.2721.17.camel@perches.com>  <5480DFB5.4090708@users.sourceforge.net> <1417733101.2721.20.camel@perches.com> <alpine.DEB.2.02.1412050726000.2059@localhost6.localdomain6> <54816700.6090501@users.sourceforge.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 5 Dec 2014, SF Markus Elfring wrote:

> > Markus, are you sure that you cannot use netdev_warn in this case?
>
> No. - I did not become familiar enough with the software infrastructure around
> the mppe_rekey() function.
>
> I do not see so far how I could determine a pointer for the first parameter there.
> The data structure "ppp_mppe_state" (which is referenced by the input variable
> "state") does not contain corresponding context information, does it?

Indeed, I also don't see anything promising.

julia
