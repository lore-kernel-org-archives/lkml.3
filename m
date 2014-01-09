Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705AbaAIHLH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 02:11:07 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:41853 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaAIHLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 02:11:05 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <20140106121317.bada4233ec3fec40f79735cc@canb.auug.org.au>
References: <20140106121317.bada4233ec3fec40f79735cc@canb.auug.org.au>
Date: Wed, 8 Jan 2014 23:11:03 -0800
Message-ID: <CAOesGMgJe9KR2muA4F9EaXYpDFDLxVZsKOj-8qZFbDZTiRBuww@mail.gmail.com>
Subject: Re: linux-next: manual merge of the sh tree with the tree
From: Olof Johansson <olof@lixom.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paul Mundt <lethal@linux-sh.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bastian Hecht <hechtb@gmail.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Simon Horman <horms+renesas@verge.net.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 5, 2014 at 5:13 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Paul,
>
> Today's linux-next merge of the sh tree got conflicts in
> drivers/tty/serial/sh-sci.c and include/linux/serial_sci.h between
> commits 8fb9631c517b ("serial: sh-sci: Sort headers alphabetically"),
> 20bdcab8268c ("serial: sh-sci: Add OF support") and probably others from
> the arm-soc tree and commits ada80ee7fa60 ("serial: sh-sci: Add OF
> support") and b19ef75c56e9 ("serial: sh-sci: OF definitions need
> linux/of.h") from the sh tree.
>
> The arm-soc tree version is dated much more recently than
> the sh tree version and conflicts badly, so for today I have just dropped
> the sh tree (everything in there was committed before April 2013).  Please
> figure this out.

The request to merge the sh code came through Simon with claimed
agreement from SH maintainers to do so -- I didn't verify this since
they have in the past been well-coordinated. Simon?



-Olof
