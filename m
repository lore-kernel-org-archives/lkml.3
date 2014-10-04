Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511AbaJDLeS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 07:34:18 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:56810 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbaJDLeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 07:34:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Valentin Rothberg <valentinrothberg@gmail.com>,
        Peter Griffin <peter.griffin@linaro.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [next-20141003] USB: host: st: fix typo 'CONFIG_USB_EHCI_HCD_ST'
Date: Sat, 04 Oct 2014 13:33:57 +0200
Message-ID: <3636554.BfmsPxFGhz@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1412324504.19413.76.camel@x220>
References: <1412324504.19413.76.camel@x220>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ipoyFBLhaHM6kLCTIIkJS879IRMv7TioTq5k1bJUYXt
 mwjesrTGGU2oJUw4SeGYKOpsSI/NMc1tySQ7vMMEoOhPCn4bop
 1zoiGGf4hfKUIbQY5AvsFTr93dc2eFHOU/KXG6e1/SEyQT5yDZ
 NyAtV0QpGTZdAHOVLo0MYPA26eEziFpNZ4ZWHcs/H02T4KFATf
 efGQRY6z8H8pXE/34kr8tTAZFUt/itky14eqpKY9cFaYzQaQpS
 uB9DGxlMpPa1AG2y4RlM/0Ahkh22KMQ8h7CDzIsOurtO6FEQGL
 v+6NqCik/9XGIWCKkWU9Fzd7ZXAmTgRWPlTo1y+QvJwR4d+lPx
 SeWBtuYkzlAhrkYCZVm0=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 October 2014 10:21:44 Paul Bolle wrote:
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> Fixes: 905e300e1043 ("USB: host: st: fix ehci/ohci driver selection")
> ---
> drivers/usb/host/ehci-st.o actually builds (on x86_64. that is) so
> there's no _obvious_ reason not to fix this typo.
> 

I was about to post the same fix, thanks a lot for addressing this.
Sorry for my stupid mistake.

Acked-by: Arnd Bergmann <arnd@arndb.de>
