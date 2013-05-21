Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab3EUGXL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 02:23:11 -0400
Received: from mail-qe0-f52.google.com ([209.85.128.52]:45239 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024Ab3EUGXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 02:23:09 -0400
MIME-Version: 1.0
In-Reply-To: <20130520210127.GF24555@two.firstfloor.org>
References: <20130520101552.14133.45953.stgit@ladj378.jer.intel.com>
	<20130520101622.14133.21998.stgit@ladj378.jer.intel.com>
	<CAJZOPZJx8vpSWqOhmN65gn=vi7hWXQO_J01+hAwGY9RwetX3DA@mail.gmail.com>
	<20130520203307.GE24555@two.firstfloor.org>
	<CAJZOPZJwcgShs-FCaXmPmigdu55ZSt08WnJjadcOi+-_AMq=oA@mail.gmail.com>
	<20130520210127.GF24555@two.firstfloor.org>
Date: Tue, 21 May 2013 09:23:08 +0300
Message-ID: <CAJZOPZJVidn+umCvpcyB0Xf_Ah0ycezAN_CeaBKtx1UV7bggVw@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 3/4] ixgbe: Add support for ndo_ll_poll
From: Or Gerlitz <or.gerlitz@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        Dave Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>, HPA <hpa@zytor.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 12:01 AM, Andi Kleen <andi@firstfloor.org> wrote:
>
> On Mon, May 20, 2013 at 11:42:37PM +0300, Or Gerlitz wrote:
> > On Mon, May 20, 2013 at 11:33 PM, Andi Kleen <andi@firstfloor.org> wrote:
> >
> > >
> > > This is discussed in 0/x
> > >
> >
> > I am not with you, V3's cover letter is empty, and in V2's cover letter I
> > don't see that
>
> It was here. Looks like Eliezer didn't reuse the full cover later.
> http://www.gossamer-threads.com/lists/linux/kernel/1715294?page=last
>


Grepping for "ixgbe" in the link you sent only brings the following hits:

Patch 3 shows how this method would be implemented for the ixgbe driver.
Patch 4 adds statistics to the ixgbe driver for ndo_ll_poll events.

does "shows how this method would be implemented" means patch #4 is
just RFC or proof-of-concept code and is not actually submitted for
acceptance?
