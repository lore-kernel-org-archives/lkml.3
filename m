Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab3AVOPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 09:15:33 -0500
Received: from mail.savoirfairelinux.com ([209.172.62.77]:50022 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab3AVOPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 09:15:31 -0500
Date: Tue, 22 Jan 2013 09:15:30 -0500 (EST)
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: simon@mungewell.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <118417672.210985.1358864130303.JavaMail.root@mail.savoirfairelinux.com>
In-Reply-To: <alpine.LNX.2.00.1301221443320.20374@pobox.suse.cz>
Subject: Re: [PATCH v2] HID: add ThingM blink(1) USB RGB LED support
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [173.246.24.133]
X-Mailer: Zimbra 7.1.4_GA_2555 (ZimbraWebClient - FF3.0 (Linux)/7.1.4_GA_2555)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > The vendor's name is "ThingM" and the product's name is "blink(1)",
> > not "blink".
> > Given that, would you prefer to keep "blink(1)::1234", or would it
> > rather be
> > "thingm-blink1::1234" (avoiding parenthesis)?
> > 
> > I ask the same question for the driver name, which is actually
> > "blink(1)".
> 
> Actually, for HID bus drivers, we are mostly following the convention
> of
> having just the vendor name in the driver, see hid-microsoft,
> hid-logitech, etc.
> 
> So it'd make most sense to me to name the driver hid-thingm, and in
> case
> it is driving blink(1) device (no other devices will be driven by it
> currently), let it create /sys/class/leds/blink1...

Ok, makes sense to me!

Thanks,
Vivien
