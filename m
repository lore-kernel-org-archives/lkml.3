Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589AbaDHL21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 07:28:27 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35733 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216AbaDHL2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 07:28:25 -0400
Date: Tue, 8 Apr 2014 12:27:26 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Dave Hansen <dave@sr71.net>
Cc: Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-serial@vger.kernel.org,
        jslaby@suse.cz
Subject: Re: post 3.14 serial regression
Message-ID: <20140408122726.227f3da8@alan.etchedpixels.co.uk>
In-Reply-To: <5343416F.8010201@sr71.net>
References: <5343416F.8010201@sr71.net>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> At the end, you can see that init is somehow dying.  If I revert this
> patch, init is happy again and doesn't die, and the serial console works
> like before.

Can you check if init is getting a SIGHUP - possibly its opening the
device and when it goes away gets a hangup which it isn't catching ?

Alan
