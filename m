Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608AbaLGUnj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 15:43:39 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:8490 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753556AbaLGUnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 15:43:35 -0500
X-IronPort-AV: E=Sophos;i="5.07,534,1413237600"; 
   d="scan'208";a="111936499"
Date: Sun, 7 Dec 2014 21:43:33 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
cc: Bjorn Helgaas <bhelgaas@google.com>, kernel-janitors@vger.kernel.org,
        joe@perches.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/20] PCI: fix misspelling of current function in
 string
In-Reply-To: <87lhmj42h3.fsf@rasmusvillemoes.dk>
Message-ID: <alpine.DEB.2.02.1412072143170.2235@localhost6.localdomain6>
References: <1417980062-25151-1-git-send-email-Julia.Lawall@lip6.fr> <1417980062-25151-4-git-send-email-Julia.Lawall@lip6.fr> <87lhmj42h3.fsf@rasmusvillemoes.dk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 7 Dec 2014, Rasmus Villemoes wrote:

> On Sun, Dec 07 2014, Julia Lawall <Julia.Lawall@lip6.fr> wrote:
> 
> > Replace a misspelled function name by %s and then __func__.
> >
> > The function name begins with pci, not cpci.
> ...
> >  	result = cpci_hotplug_init(debug);
> >  	if (result) {
> > -		err("cpci_hotplug_init with error %d\n", result);
> > +		err("%s with error %d\n", __func__, result);
> >  		return result;
> >  	}
> 
> This one seems to be a false positive; I think the err() is reporting on
> the result from the call of the function which is indeed called
> cpci_hotplug_init.

Agreed.  Thanks.

julia
