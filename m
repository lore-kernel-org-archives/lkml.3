Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978AbaKCQoQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 11:44:16 -0500
Received: from tex.lwn.net ([70.33.254.29]:38245 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170AbaKCQoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 11:44:15 -0500
Date: Mon, 3 Nov 2014 11:44:12 -0500
From: Jonathan Corbet <corbet@lwn.net>
To: Stephan Mueller <smueller@chronox.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Marek Vasut <marex@denx.de>,
        Jason Cooper <cryptography@lakedaemon.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 01/11] crypto: Documentation - crypto API high level
 spec
Message-ID: <20141103114412.78632304@lwn.net>
In-Reply-To: <4303532.NGaUQ44sQJ@tachyon.chronox.de>
References: <6375771.bx7QqLJLuR@tachyon.chronox.de>
	<4163724.RCMDlx8dmE@tachyon.chronox.de>
	<20141103083439.635f5cb6@lwn.net>
	<4303532.NGaUQ44sQJ@tachyon.chronox.de>
Organization: LWN.net
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Nov 2014 15:18:29 +0100
Stephan Mueller <smueller@chronox.de> wrote:

> > These are all useful.  But I wonder if it would be worth the effort to turn
> > this inti a proper docbook document that automatically has everything
> > together in one place?  
> 
> How do you suggest that is done?

See Documentation/kernel-doc-nano-HOWTO.txt for an introduction to the
process.  This documentation hasn't seen a lot of maintenance recently,
but I don't think things have changed too much.  Should check that when I
get a chance...

Thanks,

jon
