Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbaJMOWc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 10:22:32 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:37844 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509AbaJMOWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 10:22:31 -0400
Date: Mon, 13 Oct 2014 16:21:56 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Carles =?iso-8859-1?Q?Pag=E8s?= <page@cubata.homelinux.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Regarding tx-nocache-copy in the Sheevaplug
Message-ID: <20141013142156.GE26864@lunn.ch>
References: <20141013105246.GD1972@vicerveza.homeunix.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141013105246.GD1972@vicerveza.homeunix.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2014 at 12:52:46PM +0200, Lluís Batlle i Rossell wrote:
> Hello,
> 
> on the 7th of January 2014 ths patch was applied:
> https://lkml.org/lkml/2014/1/7/307
> 
> [PATCH v2] net: Do not enable tx-nocache-copy by default
>         
> In the Sheevaplug (ARM Feroceon 88FR131 from Marvell) this made packets to be
> sent corrupted. I think this machine has something special about the cache.

Hi Lluís

Please could you describe your test setup. I would like to try to
reproduce the problem. I have a machine based on kirkwood 6282 and the
same ethernet.

Thanks
	Andrew
