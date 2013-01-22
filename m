Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab3AVNjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 08:39:55 -0500
Received: from mail.savoirfairelinux.com ([209.172.62.77]:47971 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455Ab3AVNjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 08:39:52 -0500
Date: Tue, 22 Jan 2013 08:39:51 -0500 (EST)
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: simon@mungewell.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <519311670.181365.1358861991305.JavaMail.root@mail.savoirfairelinux.com>
In-Reply-To: <alpine.LNX.2.00.1301221124450.20374@pobox.suse.cz>
Subject: Re: [PATCH v2] HID: add ThingM blink(1) USB RGB LED support
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [173.246.24.133]
X-Mailer: Zimbra 7.1.4_GA_2555 (ZimbraWebClient - FF3.0 (Linux)/7.1.4_GA_2555)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > > Shouldn't the name presented in the sys/class/leds directories
> > > change
> > > appropriately too?
> > 
> > The directory name for the device under /sys/class/leds is
> > "blink(1)::<serial>",
> > where <serial> is the last 4 digits of the device serial number
> > (the first 4
> > digits are always the same: "1A00"). For instance,
> > "blink(1)::1234".
> > Let me know if I misunderstood your question.
> 
> I believe that Simon's (valid) observation is that the sysfs path
> should
> reflect the name change, i.e. something along the lines of
> /sys/class/leds/thingm-blink:<serial>   ... ?

The vendor's name is "ThingM" and the product's name is "blink(1)", not "blink".
Given that, would you prefer to keep "blink(1)::1234", or would it rather be
"thingm-blink1::1234" (avoiding parenthesis)?

I ask the same question for the driver name, which is actually "blink(1)".

Thanks,
Vivien
