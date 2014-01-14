Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbaANMBP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 07:01:15 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50295 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbaANMBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 07:01:12 -0500
Date: Tue, 14 Jan 2014 12:01:03 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.13-rc8
Message-ID: <20140114120103.436d190b@alan.etchedpixels.co.uk>
In-Reply-To: <CA+55aFwLXnW-GWKNcUCrpS5e7fd_0ZoKk83H4qMJNUS_WCF_3A@mail.gmail.com>
References: <CA+55aFwLXnW-GWKNcUCrpS5e7fd_0ZoKk83H4qMJNUS_WCF_3A@mail.gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Jan 2014 20:33:03 +0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Another week, another RC. And things look fine.

It seems to hate Baytrail/T

My ASUS T100TA has gone from 3.11 'needs video=VGA-1:blah' to get the mode
right but otherwise running nicely and playing 3D games to 3.13-rc8

- crashes and burns during boot if the Baytrail pinctrl driver is compiled
  in
- i915 console doesn't work
- X can be kind of hacked to work by adding mode lines wit xrandr and
  turning the vga back on

Bugs filed on both issues. The pinctrl one is nasty as it makes the i915
driver crash during initialisation, so the only way you can debug it is
pretty much a USB debug cable.

Without pinctrl the crash goes away but the display still doesn't work.

Alan
