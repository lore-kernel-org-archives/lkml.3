Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031166AbaLMONG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 09:13:06 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:41151 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031110AbaLMOND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 09:13:03 -0500
Date: Sat, 13 Dec 2014 14:12:41 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: NeilBrown <neilb@suse.de>, Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Rutland <mark.rutland@arm.com>, Jiri Slaby <jslaby@suse.cz>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] TTY: add support for "tty slave" devices.
Message-ID: <20141213141241.19e6ab26@lxorguk.ukuu.org.uk>
In-Reply-To: <548A264D.8070103@hurleysoftware.com>
References: <20141211214801.4127.93914.stgit@notabene.brown>
	<20141211215943.4127.24792.stgit@notabene.brown>
	<548A264D.8070103@hurleysoftware.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 2) why is this tied to the tty core and not the serial core
>    if this is only for UART?

I'm a bit baffled why you would try and tie it to serial core given that
serial core only covers a random subset of the uart drivers we have. If
we have a USB connected device with USB gpio lines doing power management
then it needs to be tied tty core.
