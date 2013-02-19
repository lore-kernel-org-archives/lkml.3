Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198Ab3BSC4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 21:56:54 -0500
Received: from netrider.rowland.org ([192.131.102.5]:49313 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757779Ab3BSC4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 21:56:52 -0500
Date: Mon, 18 Feb 2013 21:56:51 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Jiri Slaby <jslaby@suse.cz>
cc: =?UTF-8?B?QW5qYSBOw7x0emVs?= <Anja@nuetzel-hh.de>,
        Jeff Mahoney <jeffm@suse.com>, <mmarek@suse.cz>,
        =?UTF-8?B?RGlldGVyIE7DvHR6ZWw=?= <Dieter@nuetzel-hh.de>,
        stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [regression] openSUSE 12.2 stable kernel 3.7.8-1 big USB 2.0
 slowdown
In-Reply-To: <5121FD36.3010200@suse.cz>
Message-ID: <Pine.LNX.4.44L0.1302182155510.12532-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Feb 2013, Jiri Slaby wrote:

> On 02/18/2013 06:25 AM, Anja Nützel wrote:
> > Maybe it startet with 3.7.7.
> > I could copy several MB onto my USB 2.0 sticks with 3.7.6. (I think).
> > Even with full speed.
> > 
> > With openSUSE 12.2 DVD (kernel 3.4.x) it works OK, too.
> > 
> > Now it degrates to 12 mbits (full-speed USB only).
> 
> This is an upstream 3.7.7 stable regression, I think. Some of these
> patches perhaps:
> d7da098 USB: EHCI: fix for leaking isochronous data
> caa891a USB: storage: optimize to match the Huawei USB storage devices
> and support new switch command
> 08b4bfd USB: storage: Define a new macro for USB storage match rules
> 390077b usb: Using correct way to clear usb3.0 device's remote wakeup
> feature.
> 93dffb7 USB: EHCI: fix bug in scheduling periodic split transfers
> bf79379 USB: EHCI: fix timer bug affecting port resume
> d01875f USB: EHCI: unlink one async QH at a time
> 269ef9f USB: EHCI: remove ASS/PSS polling timeout
> 
> Alan, any ideas?

A lot of people have reported problems caused by the last one 
(269ef9f).  I haven't had time to investigate yet (just got back from 
vacation).

Alan Stern

