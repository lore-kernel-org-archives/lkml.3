Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570Ab3KXAZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 19:25:27 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41057 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756380Ab3KXAZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 19:25:23 -0500
Date: Sun, 24 Nov 2013 00:25:13 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH tty-next 7/7] n_tty: trace input/read flow control
Message-ID: <20131124002513.0a806665@alan.etchedpixels.co.uk>
In-Reply-To: <1385135965-4235-8-git-send-email-peter@hurleysoftware.com>
References: <1385135965-4235-1-git-send-email-peter@hurleysoftware.com>
	<1385135965-4235-8-git-send-email-peter@hurleysoftware.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Nov 2013 10:59:25 -0500
Peter Hurley <peter@hurleysoftware.com> wrote:

> Instrument .receive_buf() and read() paths with trace_printk's
> to aid in debugging flow control changes.

tty devices have a device, we have a dev_dbg() layer. The old tty trace
predates this but there isn't really any excuse for not using it now that
I can see ?

Alan
