Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbaDFRVc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 13:21:32 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:33831 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504AbaDFRV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 13:21:29 -0400
Date: Sun, 6 Apr 2014 18:21:00 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Struan Bartlett <struan.bartlett@gmail.com>
Cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
        Andreas Schwab <schwab@linux-m68k.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Nikolay Aleksandrov <nikolay@redhat.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@resnulli.us>, Joe Perches <joe@perches.com>,
        Dan Aloni <alonid@postram.com>
Subject: Re: [PATCH v3] netconsole: Add tty driver
Message-ID: <20140406182100.5206758e@alan.etchedpixels.co.uk>
In-Reply-To: <20140402185904.GD11734@NewsNow.co.uk>
References: <20140402185904.GD11734@NewsNow.co.uk>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2014 19:59:04 +0100
Struan Bartlett <struan.bartlett@gmail.com> wrote:

> Adds tty driver to netconsole module. 

NAK

You don't need to add a tty driver to any console to do this. We have a
ttyprintk driver that works with *any* console today.

Alan
