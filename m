Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300AbaJMPs2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 11:48:28 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:45426 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752734AbaJMPs1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 11:48:27 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 77.231.195.203
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+9qjLhBRhatAgXM6Q9AoYN
Date: Mon, 13 Oct 2014 17:48:07 +0200
From: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        Carles =?iso-8859-1?Q?Pag=E8s?= <page@cubata.homelinux.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Regarding tx-nocache-copy in the Sheevaplug
Message-ID: <20141013154807.GN1972@vicerveza.homeunix.net>
References: <20141013105246.GD1972@vicerveza.homeunix.net>
 <20141013142156.GE26864@lunn.ch>
 <20141013143138.GJ1972@vicerveza.homeunix.net>
 <1413211759.9362.103.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1413211759.9362.103.camel@edumazet-glaptop2.roam.corp.google.com>
X-Accept-Language: ca, es, eo, ru, en, jbo, tokipona
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2014 at 07:49:19AM -0700, Eric Dumazet wrote:
> On Mon, 2014-10-13 at 16:31 +0200, Lluís Batlle i Rossell wrote:
> > Enabling tx offload and disabling tx-nocache-copy, making the machine *send* a
> > lot of ssh traffic (sftp for example) makes ssh fail HMAC. It's quite easy to
> > reproduce here.
> > 
> > As for the hardware, it's an old sheevaplug board.
> 
> 
> Have you tried disabling TSO only, and are you using the latest kernel ?
> 
> Ezequiel Garcia added lot of changes recently.
> 
> 

Is TSO TCP segmentation offload? It's disabled. The kernel is 3.16.3 (debian).
https://packages.debian.org/testing/kernel/linux-image-3.16-2-kirkwood

