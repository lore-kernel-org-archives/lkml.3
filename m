Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934523Ab3E1PCm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 11:02:42 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:53691 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934447Ab3E1PCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 11:02:39 -0400
Message-ID: <1369753354.2272.2.camel@roadrunner.fritz.box>
Subject: Re: [PATCH] hid: driver for PS2/3 Buzz controllers
From: Colin Leitner <colin.leitner@googlemail.com>
To: Bastien Nocera <hadess@hadess.net>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 28 May 2013 17:02:34 +0200
In-Reply-To: <1369745595.12005.11.camel@novo>
References: <1369587150.4240.4.camel@roadrunner.fritz.box>
	 <alpine.LNX.2.00.1305271628540.3914@pobox.suse.cz>
	 <1369690865.2369.5.camel@roadrunner.fritz.box>
	 <alpine.LNX.2.00.1305281018250.3914@pobox.suse.cz>
	 <1369745595.12005.11.camel@novo>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I would have preferred it if the single device (the USB adapter)
showed
> 4 input devices each with 5 buttons and a LED, rather than a single
> device with 4 LEDs and 20 buttons.
 
That's quite a good idea. Are there any existing drivers with a similiar
feature?


