Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbaBVV5I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 16:57:08 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:37760 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaBVV5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 16:57:04 -0500
Date: Sat, 22 Feb 2014 21:56:09 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        Beat Bolli <bbolli@ewanet.ch>, Pavel Roskin <proski@gnu.org>,
        linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        David Sterba <dsterba@suse.cz>, Felipe Balbi <balbi@ti.com>,
        Grant Edwards <grant.b.edwards@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Hal Murray <murray+fedora@ip-64-139-1-69.sjc.megapath.net>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] tty: Fix low_latency BUG
Message-ID: <20140222215609.3c88b765@alan.etchedpixels.co.uk>
In-Reply-To: <1393072281-5814-1-git-send-email-peter@hurleysoftware.com>
References: <1393072281-5814-1-git-send-email-peter@hurleysoftware.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Remove the low_latency rx steering from tty_flip_buffer_push();
> however, leave the knob as an optional hint to drivers that can
> tune their rx fifos and such like. Cleanup stale code comments
> regarding low_latency.
> 
> [1] https://lkml.org/lkml/2014/2/20/434
> 
> Reported-by: Beat Bolli <bbolli@ewanet.ch>
> Reported-by: Pavel Roskin <proski@gnu.org>
> Cc: Grant Edwards <grant.b.edwards@gmail.com>
> Cc: Stanislaw Gruszka <sgruszka@redhat.com>
> Cc: Hal Murray <murray+fedora@ip-64-139-1-69.sjc.megapath.net>
> Cc: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
> Cc: <stable@vger.kernel.org> # 3.12.x+
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>

Signed-off-by: Alan Cox <alan@linux.intel.com>

Yay.. thats an annoying historical pain in the butt gone.

