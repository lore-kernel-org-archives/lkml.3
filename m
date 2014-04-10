Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030333AbaDJLPE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 07:15:04 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:38672 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934795AbaDJLPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 07:15:00 -0400
Date: Thu, 10 Apr 2014 12:14:37 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Dave Hansen <dave@sr71.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: post 3.14 serial regression
Message-ID: <20140410121437.7d4dd9a1@alan.etchedpixels.co.uk>
In-Reply-To: <CAMuHMdXtz_W7LCJeOG9--ZmmH4js40-urueCTbS98t8oBgnYCw@mail.gmail.com>
References: <5343416F.8010201@sr71.net>
	<20140408122726.227f3da8@alan.etchedpixels.co.uk>
	<5344642A.2020703@sr71.net>
	<53446C57.5000504@intel.com>
	<20140409003648.GB32273@kroah.com>
	<CAMuHMdXSa0Ku2f1CR3j5pGOp_joQomc2Cnz=apGRR1K0Eb2qOQ@mail.gmail.com>
	<5345A7B3.7020005@sr71.net>
	<CAMuHMdXtz_W7LCJeOG9--ZmmH4js40-urueCTbS98t8oBgnYCw@mail.gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I also noticed that unbinding and rebinding the driver doesn't re-attach it
> as a serial console.

Correct. The serial "console" is not hot pluggable.

http://blog.gmane.org/gmane.linux.serial/month=20090301/page=5

related 2009 discussion ..

Alan
