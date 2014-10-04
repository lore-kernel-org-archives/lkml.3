Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbaJDNXZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 09:23:25 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:56312 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750921AbaJDNXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 09:23:24 -0400
Message-ID: <1412429000.21058.7.camel@x220>
Subject: Re: [PATCH] [next-20141003] USB: host: st: fix typo
 'CONFIG_USB_EHCI_HCD_ST'
From: Paul Bolle <pebolle@tiscali.nl>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Valentin Rothberg <valentinrothberg@gmail.com>,
        Peter Griffin <peter.griffin@linaro.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 04 Oct 2014 15:23:20 +0200
In-Reply-To: <3636554.BfmsPxFGhz@wuerfel>
References: <1412324504.19413.76.camel@x220> <3636554.BfmsPxFGhz@wuerfel>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Oct 2014 13:23:21.0040 (UTC) FILETIME=[5E04C500:01CFDFD6]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-10-04 at 13:33 +0200, Arnd Bergmann wrote:
> I was about to post the same fix, thanks a lot for addressing this.

You're welcome. I just figured that sending a (second) message regarding
this typo would have been about as much trouble as sending a one line
patch, so I sent that patch.

> Sorry for my stupid mistake.

That typo was rather easy to make and hard to notice (make won't shout
at you for using an unknown macro, etc). See the thread starting at
https://lkml.kernel.org/r/1411730854.7866.10.camel@x220 for what I've
been doing lately to try to catch these type of things early (ie, in
linux-next) and for how Valentin hopes to automate that properly.


Paul Bolle

