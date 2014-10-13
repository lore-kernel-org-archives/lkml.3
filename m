Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbaJMMc3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 08:32:29 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:22775 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642AbaJMMc2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 08:32:28 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 77.231.195.203
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/DfFevnaVM3SBoDvBcwogA
Date: Mon, 13 Oct 2014 14:32:17 +0200
From: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Carles =?iso-8859-1?Q?Pag=E8s?= <page@cubata.homelinux.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Regarding tx-nocache-copy in the Sheevaplug
Message-ID: <20141013123217.GF1972@vicerveza.homeunix.net>
References: <20141013105246.GD1972@vicerveza.homeunix.net>
 <1413203171.9362.81.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1413203171.9362.81.camel@edumazet-glaptop2.roam.corp.google.com>
X-Accept-Language: ca, es, eo, ru, en, jbo, tokipona
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2014 at 05:26:11AM -0700, Eric Dumazet wrote:
> On Mon, 2014-10-13 at 12:52 +0200, Lluís Batlle i Rossell wrote:
> > Hello,
> > 
> > on the 7th of January 2014 ths patch was applied:
> > https://lkml.org/lkml/2014/1/7/307
> > 
> > [PATCH v2] net: Do not enable tx-nocache-copy by default
> >         
> > In the Sheevaplug (ARM Feroceon 88FR131 from Marvell) this made packets to be
> > sent corrupted. I think this machine has something special about the cache.
> > 
> > Enabling back this tx-nocache-copy (as it used to be before the patch) the
> > transfers work fine again. I think that most people, encountering this problem,
> > completely disable the tx offload instead of enabling back this setting.
> > 
> > Is this an ARM kernel problem regarding this platform?
> 
> Which NIC and driver is this exactly ?

According to dmesg in 3.10.1:
[    7.858872] mv643xx_eth: MV-643xx 10/100/1000 ethernet driver version 1.4
[    7.866001] mv643xx_eth_port mv643xx_eth_port.0 eth0: port 0 with MAC address 00:50:43:01:d1:bb

Regards,
Lluís.
