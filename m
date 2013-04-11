Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934041Ab3DKSop (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 14:44:45 -0400
Received: from lan.nucleusys.com ([92.247.61.126]:58424 "EHLO
	zztop.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752376Ab3DKSon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 14:44:43 -0400
Date: Thu, 11 Apr 2013 21:44:19 +0300 (EEST)
From: Petko Manolov <petkan@nucleusys.com>
X-X-Sender: petkan@fry
To: Dan Williams <dcbw@redhat.com>
cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: [PATCH] net: usb: active URB submitted multiple times
In-Reply-To: <1365698297.22668.5.camel@dcbw.foobar.com>
Message-ID: <alpine.DEB.2.02.1304112138370.4309@fry>
References: <alpine.DEB.2.02.1304102354010.9358@fry>  <20130410.232241.1038793023507666278.davem@davemloft.net>  <alpine.DEB.2.02.1304110956110.4237@fry> <1365698297.22668.5.camel@dcbw.foobar.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Apr 2013, Dan Williams wrote:

> On Thu, 2013-04-11 at 10:09 +0300, Petko Manolov wrote:
> > From: Petko Manolov <petkan@nucleusys.com>
> > 
> > (For inclusion in 3.10, diff against latest net-next.)
> 
> Your mail client replaced tabs with spaces.  Make sure when adding the 
> patch to the mail, you choose the "preformatted" option or whatever the 
> client has to ensure that the patch text itself is not modified when 
> pasting it into the mail.

The patch is indeed fucked up.  Some tabs survived Apline's take on them, 
but not nearly enough.  I am sorry for the noise.  It's been a while since 
i last submitted a patch.  Lets hope third time will be the charm...


cheers,
Petko
