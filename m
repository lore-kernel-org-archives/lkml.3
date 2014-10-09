Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933033AbaJIVt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:49:58 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:50088 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757655AbaJIVtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:49:49 -0400
Date: Thu, 9 Oct 2014 22:49:22 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "xinhui.pan" <xinhuix.pan@intel.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org,
        "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
        mnipxh <mnipxh@gmail.com>
Subject: Re: [PATCH] tty/n_gsm.c: do not clear gsm_mux entry when the gsm is
 not closed
Message-ID: <20141009224922.1eeecf63@alan.etchedpixels.co.uk>
In-Reply-To: <5436E0C5.3060907@hurleysoftware.com>
References: <53D0CF0D.9060103@intel.com>
	<20140727180953.GA7232@kroah.com>
	<53D5F8C9.4070008@intel.com>
	<20140728151324.GA12973@kroah.com>
	<5436DB9A.6040801@hurleysoftware.com>
	<20141009191351.GA4256@kroah.com>
	<5436E0C5.3060907@hurleysoftware.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > What happened to the gsm driver maintainers?
> 
> hahaha
> 
> $ ./scripts/get_maintainer.pl -f drivers/tty/n_gsm.c 
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> (supporter:TTY LAYER)
> Jiri Slaby <jslaby@suse.cz> (supporter:TTY LAYER)
> linux-kernel@vger.kernel.org (open list)


We have a bunch of folks in Intel working on some improvements to it. I'll
poke them tomorrow since I think we are one of the main users.

Alan
