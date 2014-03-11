Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985AbaCKMAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:00:47 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:59812 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584AbaCKMAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:00:44 -0400
Date: Tue, 11 Mar 2014 12:00:34 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>
Subject: Re: serial core: crash / race condition on unbind
Message-ID: <20140311120034.632ff833@alan.etchedpixels.co.uk>
In-Reply-To: <531EF864.5020104@hurleysoftware.com>
References: <CAMuHMdVV_NrQ3PPJwPNx7MoM9TWLdk02d+10zNipNcC7VC0HAA@mail.gmail.com>
	<CAMuHMdVwpQEWAVHA5BO2xXzaNc1DTdteDMWFHQ=MFJoo4Afm_A@mail.gmail.com>
	<531E7F81.20400@hurleysoftware.com>
	<CAMuHMdUeUjuBe0tWpYBZqwqWT=euPAn6fwzmXMYCP573Q1BDXQ@mail.gmail.com>
	<531EF864.5020104@hurleysoftware.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > No one unbinds serial drivers using serial_core, as all these drivers are
> > for fixed hardware?
> 
> Yep, never tested until now :)
> Do you need this to work?
> 
> > Hot-pluggable usb-serial doesn't use serial_core.
> 
> I guess none of the 8250 PCI adapters are hot-pluggable...

pcmcia 8250 certainly was and worked - but then I've not had pcmcia ports
in years 8)

