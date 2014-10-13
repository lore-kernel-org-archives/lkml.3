Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbaJMOcC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 10:32:02 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:12778 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029AbaJMOb6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 10:31:58 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 77.231.195.203
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19b9A0YXYNu12o1LxSb2BkM
Date: Mon, 13 Oct 2014 16:31:38 +0200
From: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>
To: Andrew Lunn <andrew@lunn.ch>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Carles =?iso-8859-1?Q?Pag=E8s?= <page@cubata.homelinux.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Regarding tx-nocache-copy in the Sheevaplug
Message-ID: <20141013143138.GJ1972@vicerveza.homeunix.net>
References: <20141013105246.GD1972@vicerveza.homeunix.net>
 <20141013142156.GE26864@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20141013142156.GE26864@lunn.ch>
X-Accept-Language: ca, es, eo, ru, en, jbo, tokipona
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enabling tx offload and disabling tx-nocache-copy, making the machine *send* a
lot of ssh traffic (sftp for example) makes ssh fail HMAC. It's quite easy to
reproduce here.

As for the hardware, it's an old sheevaplug board.

On Mon, Oct 13, 2014 at 04:21:56PM +0200, Andrew Lunn wrote:
> On Mon, Oct 13, 2014 at 12:52:46PM +0200, Lluís Batlle i Rossell wrote:
> > Hello,
> > 
> > on the 7th of January 2014 ths patch was applied:
> > https://lkml.org/lkml/2014/1/7/307
> > 
> > [PATCH v2] net: Do not enable tx-nocache-copy by default
> >         
> > In the Sheevaplug (ARM Feroceon 88FR131 from Marvell) this made packets to be
> > sent corrupted. I think this machine has something special about the cache.
> 
> Hi Lluís
> 
> Please could you describe your test setup. I would like to try to
> reproduce the problem. I have a machine based on kirkwood 6282 and the
> same ethernet.
> 
> Thanks
> 	Andrew
