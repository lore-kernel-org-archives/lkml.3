Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab3IXRuo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 13:50:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783Ab3IXRum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 13:50:42 -0400
Date: Tue, 24 Sep 2013 13:50:30 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Joseph Salisbury <joseph.salisbury@canonical.com>
cc: Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        Mirko Lindner <mlindner@marvell.com>, linux-kernel@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>, netdev@vger.kernel.org,
        member graysky <graysky@archlinux.us>,
        Greg KH <gregkh@linuxfoundation.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [REGRESSION][BISECTED] skge: add dma_mapping check
In-Reply-To: <5241ACEA.6010402@canonical.com>
Message-ID: <alpine.LRH.2.02.1309241345190.28370@file01.intranet.prod.int.rdu2.redhat.com>
References: <1379494844.2294.12.camel@ThinkPad-X230.localdomain>  <20130918220819.GA11989@electric-eye.fr.zoreil.com> <1379581391.2403.5.camel@ThinkPad-X230.localdomain> <5241ACEA.6010402@canonical.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 24 Sep 2013, Joseph Salisbury wrote:

> On 09/19/2013 05:03 AM, Igor Gnatenko wrote:
> > Please, send patch.
> >
> The patch is in mainline as of 3.12-rc2 as commit:
> 
> Author: Mikulas Patocka <mpatocka@redhat.com>
> Date:   Thu Sep 19 14:13:17 2013 -0400
> 
>     skge: fix broken driver
> 
> I don't see that the commit was Cc'd to stable.  Mikulas, we might need
> to send a request directly to the stable maintainers and reqeust that
> the commit be pulled into stable, in case they didn't notice the request
> in the commit message.

The patch needs to be added to 3.11 stable tree. David Miller's networking 
tree has a rule that it doesn't want "Cc: stable@kernel.org" in patches 
submitted through it.

So, David hopefully submits the patch to the stable tree on his own.

Mikulas
